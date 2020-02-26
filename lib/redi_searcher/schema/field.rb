module RediSearcher
  class Schema
    class Field
      OPTIONS_FLAGS = {
        text: [:no_stem],
        all: [:sortable, :no_index]
      }

      OPTIONS_PARAMS = {
        text: [:phonetic, :weight],
        tag: [:separator]
      }

      attr_reader :name, :type, :options

      def initialize(name, type, **options)
        @name = name
        @type = type
        @options = options
      end

      def serialize
        [name.to_s, type.to_s.upcase, flags_for_type(type, options), params_for_type(type, options), flags_for_type(:all, options)].flatten
      end

      def flags_for_type(type, **options)
        self.class::OPTIONS_FLAGS[type].to_a.map do |key|
          key.to_s.upcase if options[key]
        end.compact
      end

      def params_for_type(type, **options)
        self.class::OPTIONS_PARAMS[type].to_a.map do |key|
          [key.to_s.upcase, *options[key]] unless options[key].nil?
        end.compact
      end

    end
  end
end
