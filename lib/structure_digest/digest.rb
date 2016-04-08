require 'yaml'

module StructureDigest
  class Digest
    def initialize(opts={})
      @tree = opts[:tree] || false
    end

    def self.diff(h1,h2)
      paths1 = []
      paths2 = []
      gather_paths(h1, paths1)
      paths1 = paths1.map(&:serialize)
      gather_paths(h2, paths2)
      paths2 = paths2.map(&:serialize)

      added = (paths2 - paths1)
      removed = (paths1 - paths2)
      (added + removed).sort.map do |p|
        if removed.include?(p)
          "- #{p}"
        elsif added.include?(p)
          "+ #{p}"
        end
      end
    end

    def injest_yml_files(file_paths)
      file_paths.each do |p|
        y = YAML.load_file(p)
        Digest.gather_paths(y, paths)
      end
      @abstract_paths = paths.map(&:abstract).uniq
      self
    end

    def add_validation(shorthand, &validateFn)
      raise "isn't applicable for core paths of schema" unless @abstract_paths.include? SchemaParts::AbstractPath.from_shorthand(shorthand)
      validators[shorthand] ||= []
      validators[shorthand] << validateFn
    end

    def validate(hash)
      paths = []
      Digest.gather_paths(hash, paths)
      paths.all? do |p|
        print '.'
        @abstract_paths.any?{|my_p| my_p.accepts(p) } && validators_for(p).all?{|v| v.call(p.last[:value]) }
      end.tap do
        puts
      end
    end

    def validators_for(p)
      validators[p.abstract.serialize] || []
    end

    def shorthand
      if @tree
        root = {}
        @abstract_paths.each do |apath|
          append_to_tree(root, apath.parts)
        end
        sio = StringIO.new
        pretty_print(sio, root)
        sio.rewind
        sio.read.chomp
      else
        @abstract_paths.map(&:serialize).uniq.sort.join("\n")
      end
    end

    def pretty_print(io, tree, level=0)
      tree.keys.sort.each do |k|
        v = tree[k]
        io << '  '*level + k
        if v.keys.empty?
          io << "\n"
        elsif v.keys.size == 1
          pretty_print(io, v, level)
        else
          io << "\n"
          pretty_print(io, v, level+1)
        end
      end
    end

    def append_to_tree(tree, parts)
      return if parts.empty?
      append_to_tree(tree[parts.first.serialize] || (tree[parts.first.serialize] = {}), parts.drop(1))
    end

    private

    def paths
      @paths ||= []
    end

    def validators
      @validators ||= {}
      @validators
    end

    def self.gather_paths(node, solutions=[], partial_solution=SchemaParts::Path.new)
      if Array === node
        if node.empty?
          solutions << (partial_solution.add_part(SchemaParts::Value.new(node)))
        else
          node.each.with_index do |e, i|
            self.gather_paths(e, solutions, partial_solution.add_part(SchemaParts::ArrayDereference.new(i)))
          end
        end
      elsif Hash === node
        if node.empty?
          solutions << (partial_solution.add_part(SchemaParts::Value.new(node)))
        else
          node.each do |k,v|
            self.gather_paths(v, solutions, partial_solution.add_part(SchemaParts::HashDereference.new(k)))
          end
        end
      else
        solutions << (partial_solution.add_part(SchemaParts::Value.new(node)))
      end
      nil
    end

    def deserialize(orig_shorthand)
      SchemaParts::AbstractPath.from_shorthand(orig_shorthand)
    end
  end
end
