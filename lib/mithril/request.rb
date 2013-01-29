# lib/mithril/request.rb

module Mithril
  class Request
    def initialize(session = {})
      @session = session
    end # constructor
    
    attr_accessor :session, :input, :output
  end # class Request
end # module
