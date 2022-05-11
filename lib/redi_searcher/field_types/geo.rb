module RediSearcher
  module FieldTypes
    class Tag < Field
      TYPE = 'GEO'

      OPTIONS = {
        sortable: Params::Bolean.new(),
        unf: Params::Bolean.new(),
        noindex: Params::Bolean.new(),
        phonetic: Params::String.new(valid: ['dm:en', 'dm:fr', 'dm:pt', 'dm:es']),
      }
      
    end
  end
end