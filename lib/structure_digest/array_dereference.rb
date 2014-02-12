module StructureDigest
  module SchemaParts
    class ArrayDereference
      attr_reader :index
      def initialize(index)
        @index = index
      end

      def ==(other)
        self.class == other.class && @index == other.index
      end

      alias :eql? :==
      def hash; [@index].hash; end
      def abstract
        AbstractArrayDereference.new
      end
    end
  end
end
