module RediSearcher
  class Client
    class CommandBase
      OPTIONS_FLAGS = {}
      OPTIONS_PARAMS = {}

      private

      def serialize_options(method, **options)
        [flags_for_method(method, options), params_for_method(method, options)].flatten.compact
      end

      def flags_for_method(method, **options)
        self.class::OPTIONS_FLAGS[method].to_a.map do |key|
          key.to_s.upcase if options[key]
        end.compact
      end

      def params_for_method(method, **options)
        self.class::OPTIONS_PARAMS[method].to_a.map do |key|
          [key.to_s.upcase, *options[key]] unless options[key].nil?
        end.compact
      end

    end
  end
end
