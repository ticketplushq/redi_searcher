module RediSearcher
  class Index < Client::CommandBase

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
      Commands::Create.new(name, schema, options).serialize
    end

    def ft_drop(**options)
      Commands::DropIndex.new(name, options).serialize
    end

    def ft_search(query, **options)
      Commands::Search.new(name, query, options).serialize
    end

    def ft_info
      ['FT.INFO', name]
    end

  end
end
