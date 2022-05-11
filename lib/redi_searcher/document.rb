module RediSearcher
  class Document < Client::CommandBase
    # Fields are a Array of Fields
    attr_reader :index, :doc_id, :fields

    def initialize(index, doc_id, fields)
      @index = index
      @doc_id = doc_id
      @fields = filter_by_schema(fields)
    end

    def add(**options)
      index.client.call(ft_add(options))
    end

    private

    def ft_add(**options)
      ['HSET', "#{index.name}:#{doc_id}", *fields.]
    end

    # return a array if the field name is in the schema
    def filter_by_schema(fields)
      names = index.schema.fields.map(&:name)

      
    end

  end
end
