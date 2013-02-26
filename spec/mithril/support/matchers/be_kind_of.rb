# spec/support/matchers/be_kind_of.rb

require 'rspec'

module RSpec::Matchers::BuiltIn
  class BeAKindOf < BaseMatcher
    def match(expected, actual)
      @actual = actual
      self.match_type? expected
    end # method match
    
    def match_type?(expected)
      case
      when expected.nil?
        @actual.nil?
      when expected.is_a?(Enumerable)
        expected.reduce(false) { |memo, obj| memo || match_type?(obj) }
      else
        @actual.kind_of? expected
      end # case
    end # method match_type
  end # class
end # module
