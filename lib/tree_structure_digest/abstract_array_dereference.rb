module TreeStructureDigest
  module SchemaParts
    class AbstractArrayDereference
      def ==(other)
        self.class == other.class
      end

      def serialize
        "[]"
      end

      alias :eql? :==
      def hash; [].hash; end
    end
  end
end
