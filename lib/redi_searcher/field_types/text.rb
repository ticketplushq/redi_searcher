module RediSearcher
  module FieldTypes
    class Text < Field
      TYPE = 'TEXT'

      OPTIONS = {
        sortable: Params::Bolean.new(),
        unf: Params::Bolean.new(),
        nostem: Params::Bolaen.new(),
        noindex: Params::Bolean.new(),
        phonetic: Params::String.new(valid: ['dm:en', 'dm:fr', 'dm:pt', 'dm:es']),
        weight: Params::Number.new(default: 1),
      }
      
    end
  end
end