module RediSearcher
  class Document < Client::CommandBase
    OPTIONS_FLAGS = {
      add: [:nosave, :replace, :partial]
    }

    OPTIONS_PARAMS = {
      add: [:language, :payload],
    }

    attr_reader :index, :doc_id, :fields, :weight

    def initialize(index, doc_id, weight = nil, **fields)
      @index = index
      @doc_id = doc_id
      @fields = fields
      @weight = weight || RediSearcher::DEFAULT_WEIGHT
    end

    def add(**options)
      byebug
      index.client.call(ft_add(options))
    end

    private

    def ft_add(**options)
      ['FT.ADD', index.name , doc_id, weight, *serialize_options(:add, options), 'FIELDS', *serialize_fields]
    end

    def serialize_fields
      fields.map do |key, value|
        [(key.to_s rescue key) || key, value]
      end.compact
    end

  end
end
