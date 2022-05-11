module RediSearcher
  module FieldTypes
    class Tag < Field
      TYPE = 'TAG'

      OPTIONS = {
        sortable: Params::Bolean.new(),
        unf: Params::Bolean.new(),
        noindex: Params::Bolean.new(),
        phonetic: Params::String.new(valid: ['dm:en', 'dm:fr', 'dm:pt', 'dm:es']),
        separator: Params::String.new(default: ','),
        casesensitive: Params::Bolean.new(),
      }
      
    end
  end
end