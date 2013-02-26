# spec/mithril/support/matchers/have_accessor.rb

require 'mithril/support/matchers'

module Mithril::Support::Matchers
  class HaveAccessor
    def initialize property
      @property = property
    end # method initialize
    
    def matches? actual
      @actual = actual
      
      return false unless @actual.respond_to? @property
      
      return false if @value_set and @value != @actual.send(@property)

      true
    end # method matches
    
    def with value
      @value = value
      @value_set = true
      self
    end # with
    
    def failure_message
      return "expected #{@actual.inspect} to have accessor #{@property}" +
        "#{value_string}"
    end # method failure_message
    
    def negative_failure_message
      return "expected #{@actual.inspect} not to have accessor #{@property}" +
        "#{value_string}"
    end # method negative_failure_message
    
    def value_string
      @value_set ?
        " with value #{@value}" :
        ""
    end # method value_string
    private :value_string
  end # class
  
  def have_accessor property
    HaveAccessor.new property
  end # method have_accessor
end # module
