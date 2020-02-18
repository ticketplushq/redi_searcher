require 'redisearcher/client'
require 'redisearcher/client/command_base'

require 'redisearcher/schema'
require 'redisearcher/schema/field'

require 'redisearcher/index'
require 'redisearcher/document'



module RediSearcher
  DEFAULT_WEIGHT = '1.0'

  class << self
    def client
      @client ||= Client.new
    end
  end
end
