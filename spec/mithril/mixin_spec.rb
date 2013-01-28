# spec/mithril/mixin_spec.rb

require 'spec_helper'
require 'mithril/mixin'

describe Mithril::Mixin do
  before :each do
    foo = Module.new
    foo.send :extend, Mithril::Mixin
    foo.send :define_method, :foo do; end
    
    Mithril::Mock.const_set :Foo, foo
    
    foo_m = Module.new
    foo_m.send :define_method, :foo_m do; end
    
    Mithril::Mock::Foo.const_set :ClassMethods, foo_m
    
    bar = Module.new
    bar.send :extend, Mithril::Mixin
    bar.send :mixin, Mithril::Mock::Foo
    bar.send :define_method, :bar do; end
    
    Mithril::Mock.const_set :Bar, bar
    
    bar_m = Module.new
    bar_m.send :define_method, :bar_m do; end
    
    Mithril::Mock::Bar.const_set :ClassMethods, bar_m
    
    baz = Class.new
    baz.send :extend, Mithril::Mixin
    baz.send :mixin, Mithril::Mock::Bar
    
    Mithril::Mock.const_set :Baz, baz
  end # before each
  
  after :each do
    Mithril::Mock.send :remove_const, :Foo
    Mithril::Mock.send :remove_const, :Bar
    Mithril::Mock.send :remove_const, :Baz
  end # after each
  
  let :described_class do Mithril::Mock::Baz; end
  let :instance do described_class.new; end
  
  it { expect(Mithril::Mock::Bar).to respond_to :foo_m }
  it { expect {
    module Mithril::Mock::Bar
      foo_m
    end # module
  }.not_to raise_error }
  
  it { expect(described_class).to respond_to :foo_m }
  it { expect(instance).to respond_to :foo }
  
  it { expect(described_class).to respond_to :bar_m }
  it { expect(instance).to respond_to :bar }
end # describe
