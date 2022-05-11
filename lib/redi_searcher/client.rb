module RediSearcher
  class Client

    def initialize(redis = {}, *args)
      @redis = Redis.new(redis)
    end

    def generate_index(name, schema)
      RediSearcher::Index.new(self, name, schema)
    end

    def call(command)
      raise ArgumentError.new("unknown/unsupported command '#{command.first}'") unless valid_command?(command.first)
      with_reconnect { @redis.call(command.flatten) }
    end

    # return true or false
    def multi
      with_reconnect { @redis.multi { yield } }
    end

    private

    attr_accessor :redis

    def with_reconnect
      @redis.with_reconnect { yield }
    end

    def valid_command?(command)
      %w(FT.CREATE FT.SEARCH FT.DROPINDEX FT.INFO FT.EXPLAIN).include?(command)
    end

  end
end
