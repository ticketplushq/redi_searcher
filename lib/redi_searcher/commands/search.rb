module RediSearcher
  module Commands
    class Search < Base
      COMMAND = 'FT.SEARCH'

      OPTIONS = {
        nocontent: Params::Boolean.new(),
        verbatim: Params::Boolean.new(),
        nostopwords: Params::Boolean.new(),
        withscores: Params::Boolean.new(),
        withpayloads: Params::Boolean.new(),
        withsortkeys: Params::Boolean.new(),
        geofilter: Params::Multiple.new(types: [Params::String.new(requied: true), Params::Number.new(requied: true), Params::Number.new(requied: true), Params::Number.new(requied: true), Params::String.new(requied: true, valid: ['m', 'km', 'mi', 'ft'])]),
        inkeys: Params::Array.new(),
        infields: Params::Array.new(),
        return: Params::Array.new(),
        summarize: Params::NoImplemented.new(),
        highlight: Params::NoImplemented.new(),
        slop: Params::Number.new(),
        inorder: Params::Boolean.new(),
        language: Params::String.new(default: 'English', valid: ['Arabic', 'Basque', 'Catalan', 'Danish', 'Dutch', 'English', 'Finnish', 'French', 'German', 'Greek', 'Hungarian', 'Indonesian', 'Irish', 'Italian', 'Lithuanian', 'Nepali', 'Norwegian', 'Portuguese', 'Romanian', 'Russian', 'Spanish', 'Swedish', 'Tamil', 'Turkish', 'Chinese']),
        expander: Params::String.new(),
        scorer: Params::String.new(),
        explainscore: Params::Boolean.new(),
        payload: Params::String.new(),
        sortby: Params::Multiple.new(types: [Params::String.new(requied: true), Params::String.new(requied: true, valid: ['ASC', 'DESC'])]),
        limit: Params::Multiple.new(types: [Params::Number.new(requied: true), Params::Number.new(requied: true)]),
        timeout: Params::Number.new(),
        params: Params::NoImplemented.new(),
        dialect: Params::String.new(),
      }

      # params: Array of Params
      attr_reader :params, :query, :name

      def initialize(name, query, options = {})
        @name = name
        @query = query
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

        super(options)

        # parse the options and set the @options using the OPTIONS constant and validate the options
        @params = parse_options(options)
        validate_params
      end

      def serialize
        [COMMAND, name, query, *params.map(&:serialize)]
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

