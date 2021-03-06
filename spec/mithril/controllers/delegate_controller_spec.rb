# spec/mithril/controllers/delegate_controller_spec.rb

require 'mithril/spec_helper'
require 'mithril/controllers/delegate_controller_helper'

require 'mithril/controllers/delegate_controller'

describe Mithril::Controllers::DelegateController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::DelegateController
end # describe
