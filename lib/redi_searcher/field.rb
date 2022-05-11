module RediSearcher
    class Field

      OPTIONS = {}

      attr_reader :name, :params

      def initialize(name, type, **options)
        @name = name
        @type = type

        @params = parse_options(options)
        validate_params
      end

      def serialize
        [name.to_s, type.to_s.upcase, flags_for_type(type, options), params_for_type(type, options), flags_for_type(:all, options)].flatten
      end

      private

      # return a array of params
      def parse_options(options)
        params = []
        OPTIONS.each do |key, value|
          params << value.set(key, options[key])
        end
      end

      def validate_params
        params.each do |param|
          param.validate
        end
      end
    end
end
