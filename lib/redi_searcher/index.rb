module RediSearcher
  class Index < Client::CommandBase
    OPTIONS_FLAGS = {
      create: [:nooffsets, :nofreqs, :nohl, :nofields],
      drop: [:keepdocs],
      search: [:nocontent, :verbatim, :nostopwords, :withscores, :withsortkeys],
    }

    OPTIONS_PARAMS = {
      create: [:stopwords],
      search: [:filter, :return, :infields, :inkeys, :slop, :scorer, :sortby, :limit, :payload],
    }

    attr_reader :client, :name, :schema

    def initialize(client, name, schema)
      @client = client
      @name = name
      @schema = RediSearcher::Schema.new(schema)
    end

    def generate_document(id, fields)
      RediSearcher::Document.new(self, id, fields)
    end

    def create(**options)
      client.call(ft_create(schema, options))
    end

    def info
      Hash[*client.call(ft_info)]
    rescue Redis::CommandError
      nil
    end

    def search(query, **options)
      client.call(ft_search(query, options))
    end

    def exists?
      !info.nil?
    end

    def drop
      !client.call(ft_drop()).nil?
    rescue Redis::CommandError
      nil
    end

    private

    def ft_create(schema, **options)
      ['FT.CREATE', name , *serialize_options(:create, options), 'SCHEMA', *schema.serialize]
    end

    def ft_drop(**options)
      ['FT.DROP', name, *serialize_options(:drop, options)]
    end

    def ft_search(query, **options)
      ['FT.SEARCH', name, query, *serialize_options(:search, options)]
    end

    def ft_info
      ['FT.INFO', name]
    end

  end
end
