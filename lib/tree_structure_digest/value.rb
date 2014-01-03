module TreeStructureDigest
  module SchemaParts
    class Value
      def initialize(val)
        @value = val
      end

      def abstract
        nil
      end

      attr_reader :value
      def ==(other)
        self.class == other.class && @value == other.value
      end
      alias :eql? :==
      def hash; [@value].hash; end
    end
  end
end