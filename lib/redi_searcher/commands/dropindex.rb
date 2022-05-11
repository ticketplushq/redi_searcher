module RediSearcher
  module Commands
    class DropIndex < Base
      COMMAND = 'FT.DROPINDEX'

      OPTIONS = {
        dd: Params::Boolean.new(required: false),
      }

      # options: Array of Params
      # schema: RediSearcher::Schema
      attr_reader :params, :name

      def initialize(name, options = {})
        @name = name
        super(options)

        # parse the options and set the @options using the OPTIONS constant and validate the options
        @params = parse_options(options)
        validate_params
      end

      def serialize
        [COMMAND, name, *params.map(&:serialize)]
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
end

