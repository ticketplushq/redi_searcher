module RediSearcher
  class Document < Client::CommandBase
    OPTIONS_FLAGS = {
      add: [:nosave, :replace, :partial],
      del: [:dd]
    }

    OPTIONS_PARAMS = {
      add: [:language, :payload],
    }

    attr_reader :index, :doc_id, :fields, :weight

    def initialize(index, doc_id, weight = nil, **fields)
      @index = index
      @doc_id = doc_id
      @fields = filter_by_schema(fields)
      @weight = weight || RediSearcher::DEFAULT_WEIGHT
    end

    def add(**options)
      index.client.call(ft_add(options))
    end

    def del(**options)
      index.client.call(ft_del(options))
    end

    private

    def ft_add(**options)
      ['FT.ADD', index.name , doc_id, weight, *serialize_options(:add, options), 'FIELDS', *serialize_fields]
    end

    def ft_del(**options)
      ['FT.DEL', index.name , doc_id, *serialize_options(:del, options)]
    end

    def serialize_fields
      fields.map do |key, value|
        if value.is_a? Array
          value = serialize_tag_array(value, schema_fields[key][:options][:separator]) if schema_fields[key][:type] == :tag
        end
        [(key.to_s rescue key) || key, value]
      end.compact
    end

    def serialize_tag_array(values, separator)
      values.map { |value| value.to_s.gsub(separator, '') }.join(separator)
    end

    def schema_fields
      Hash[index.schema.fields.map {|field| [field.name, {type: field.type, options: field.options}] }]
    end

    def filter_by_schema(fields)
      fields.slice(*schema_fields.keys)
    end

  end
end
