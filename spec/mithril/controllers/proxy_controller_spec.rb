# spec/mithril/controllers/proxy_controller_spec.rb

require 'mithril/spec_helper'
require 'mithril/controllers/proxy_controller_helper'

require 'mithril/controllers/proxy_controller'

describe Mithril::Controllers::ProxyController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::ProxyController
end # describe
