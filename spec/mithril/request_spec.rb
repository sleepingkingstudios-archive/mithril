# spec/mithril/request_spec.rb

require 'mithril/spec_helper'

require 'mithril/request'

describe Mithril::Request do
  let :described_class do super(); end
  let :instance do described_class.new; end
  
  describe :constructor do
    it { expect(described_class).to construct.with(0..1).arguments }
    
    context "with a session argument" do
      let :hsh_value do { :foo => :bar }; end
      let :instance  do described_class.new hsh_value; end
      
      specify { expect(instance.session).to be hsh_value }
    end # context
  end # describe
  
  describe :session do
    specify { expect(instance).to respond_to(:session).with(0).arguments }
    
    specify { expect(instance.session).to be_a Hash }
  end # describe session
  
  describe :session= do
    let :hsh_value do { :foo => :bar }; end
    
    specify { expect(instance).to respond_to(:session=).with(1).arguments }
    
    specify "changes value when set" do
      instance.session = hsh_value
      expect(instance.session).to be hsh_value
    end # specify
  end # describe session=
  
  describe :input do
    specify { expect(instance).to respond_to(:input).with(0).arguments }
    
    specify { expect(instance.input).to be nil }
  end # describe input
  
  describe :input= do
    let :str_value do "string"; end
    
    specify { expect(instance).to respond_to(:input=).with(1).arguments }
    
    specify "changes value when set" do
      instance.input = str_value
      expect(instance.input).to eq str_value
    end # specify
  end # describe
  
  describe :output do
    specify { expect(instance).to respond_to(:output).with(0).arguments }
    
    specify { expect(instance.output).to be nil }
  end # describe
  
  describe :output= do
    let :str_value do "string"; end
    
    specify { expect(instance).to respond_to(:output=).with(1).arguments }
    
    specify "changes value when set" do
      instance.output = str_value
      expect(instance.output).to eq str_value
    end # specify
  end # describe
end # describe
