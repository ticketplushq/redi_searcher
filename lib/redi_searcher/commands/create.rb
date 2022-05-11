module RediSearcher
  module Commands
    class Create < Base
      COMMAND = 'FT.CREATE'

      OPTIONS = {
        on: Params::String.new(default: 'HASH', required: false),
        prefix: Params::Array.new(required: false),
        filter: Params::String.new(required: false),
        language: Params::String.new(default: 'English', valid: ['Arabic', 'Basque', 'Catalan', 'Danish', 'Dutch', 'English', 'Finnish', 'French', 'German', 'Greek', 'Hungarian', 'Indonesian', 'Irish', 'Italian', 'Lithuanian', 'Nepali', 'Norwegian', 'Portuguese', 'Romanian', 'Russian', 'Spanish', 'Swedish', 'Tamil', 'Turkish', 'Chinese'], required: false),
        language_field: Params::String.new(required: false),
        score: Params::Float.new(required: false),
        score_field: Params::String.new(required: false),
        payload_field: Params::String.new(required: false),
        maxtextfields: Params::Boolean.new(required: false),
        nooffsets: Params::Boolean.new(required: false),
        temporary: Params::Boolean.new(required: false),
        nohl: Params::Boolean.new(required: false),
        nofields: Params::Boolean.new(required: false),
        nofreqs: Params::Boolean.new(required: false),
        stopwords: Params::Array.new(required: false, zeroempty: true),
        skipinitialscan: Params::Boolean.new(required: false)
      }

      # options: Array of Params
      # schema: RediSearcher::Schema
      attr_reader :params, :schema, :name

      def initialize(name, options = {})
        @name = name
        super(options)
        # check if shchema is provided in the options and remove it from the options if not rise an error
        if options[:schema].nil?
          raise ArgumentError, 'Schema is required'
        else
          @schema = options[:schema]
          options.delete(:schema)
        end

        # check if the schema is a valid schema and raise an error if not
        unless @schema.is_a?(RediSearcher::Schema)
          raise ArgumentError, 'Schema is not a valid schema'
        end

        # parse the options and set the @options using the OPTIONS constant and validate the options
        @params = parse_options(options)
        validate_params
      end

      def serialize
        [COMMAND, name, *params.map(&:serialize), 'SCHEMA', *schema.serialize]
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

