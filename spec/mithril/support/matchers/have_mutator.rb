# spec/mithril/support/matchers/have_accessor.rb

require 'mithril/support/matchers'

module Mithril::Support::Matchers
  class HaveMutator
    def initialize property
      @property = property.to_s.gsub(/=$/,'').intern
    end # method initialize
    
    def matches? actual
      @actual = actual
      
      return false unless @actual.respond_to? :"#{@property}="
      
      if @value_set
        @actual.send :"#{@property}=", @value
        return false unless @value == @actual.send(@property)
      end # if
      
      true
    end # method matches?

    def with value
      @value = value
      @value_set = true
      self
    end # with
    
    def failure_message
      return "expected #{@actual.inspect} to have mutator #{@property}" +
        "#{value_string}"
    end # method failure_message

    def negative_failure_message
      return "expected #{@actual.inspect} not to have mutator #{@property}" +
        "#{value_string}"
    end # method failure_message
    
    def value_string
      @value_set ?
        " setting value #{@value}" :
        ""
    end # method value_string
    private :value_string
  end # class
  
  def have_mutator property
    HaveMutator.new property
  end # method have_accessor
end # module
