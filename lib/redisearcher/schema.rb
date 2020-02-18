module RediSearcher
  class Schema
    attr_reader :fields

    def initialize(**fields)
      @fields = []
      build_fields_params(fields).each do |value|
        @fields << Field.new(*value)
      end
    end

    def serialize
      @fields.map(&:serialize)
    end

    private

    def build_fields_params(**fields)
      fields.map{ |key, value| [key, value.is_a?(Hash) ? value.to_a : value].flatten}
    end
  end
end
