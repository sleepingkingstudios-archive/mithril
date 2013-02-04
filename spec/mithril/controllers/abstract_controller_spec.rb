# spec/controllers/mithril/abstract_controller_spec.rb

require 'mithril/spec_helper'
require 'mithril/controllers/_text_controller_helper'

require 'mithril/controllers/abstract_controller'
require 'mithril/parsers/simple_parser'

describe Mithril::Controllers::AbstractController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like "Mithril::Controllers::_TextController"
end # describe
