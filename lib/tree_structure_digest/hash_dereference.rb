module TreeStructureDigest
  module SchemaParts
    class HashDereference
      def initialize(key)
        @key = key
      end

      def serialize
        ".#{key}"
      end

      def abstract
        self
      end
      attr_reader :key
      def ==(other)
        self.class == other.class && @key == other.key
      end
      alias :eql? :==
      def hash; [@key].hash; end
    end
  end
end
