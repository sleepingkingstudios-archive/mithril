# spec/mithril_spec.rb

require 'spec_helper'

require 'mithril'

describe Mithril do
  describe "self.logger" do
    specify { expect(described_class).to respond_to(:logger).with(0).arguments }
    
    specify "has a default value" do
      expect(described_class.logger).to respond_to :log
    end # specify
  end # describe
  
  describe "self.logger=" do
    specify { expect(described_class).to respond_to(:logger=).with(1).arguments }
    
    specify "changes value when set" do
      logger = double("logger", :log => nil)
      described_class.logger = logger
      expect(described_class.logger).to be logger
    end # specify
  end # describe
end # describe