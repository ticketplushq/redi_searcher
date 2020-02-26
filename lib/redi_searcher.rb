require 'redi_searcher/client'
require 'redi_searcher/client/command_base'

require 'redi_searcher/schema'
require 'redi_searcher/schema/field'

require 'redi_searcher/index'
require 'redi_searcher/document'



module RediSearcher
  DEFAULT_WEIGHT = '1.0'

  class << self
    def client
      @client ||= Client.new
    end
  end
end
