module TreeStructureDigest
  module SchemaParts
    class Path
      def initialize(parts=[])
        @parts = parts
      end

      def abstract
        AbstractPath.new(@parts.map(&:abstract).compact)
      end

      def add_part(part)
        Path.new(@parts + [part])
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
