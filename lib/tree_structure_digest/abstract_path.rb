module TreeStructureDigest
  module SchemaParts
    class AbstractPath
      def initialize(abstract_parts)
        @parts = abstract_parts
      end

      def serialize
        @parts.map(&:serialize).join
      end

      def accepts(path)
        self == path.abstract
      end

      def add_part(part)
        AbstractPath.new(@parts + [part])
      end

      def self.from_shorthand(shorthand)
        shorthand = orig_shorthand.clone
        abstract_path = AbstractPath.new
        while !shorthand.empty?
          if key = shorthand[/^\.(\w+)/, 1]
            abstract_path = abstract_path.add_part(HashDereference.new(key))
            shorthand.sub!(/^\.\w+/, '')
          elsif shorthand[/^\[\]/]
            abstract_path = abstract_path.add_part(AbstractArrayDereference.new)
            shorthand.sub!("[]", '')
          else
            raise "shorthand #{shorthand} isn't a valid path shorthand"
          end
        end
        abstract_path
      end

      attr_reader :parts
      def ==(other)
        self.class == other.class && @parts == other.parts
      end
      alias :eql? :==
      def hash; [@parts].hash; end
    end
  end
end
