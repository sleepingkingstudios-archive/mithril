# spec/mithril/controllers/proxy_controller_helper.rb

require 'mithril/controllers/abstract_controller_helper'

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/proxy_controller'

shared_examples_for Mithril::Controllers::ProxyController do
  it_behaves_like Mithril::Controllers::AbstractController
  
  let :proxy do described_class; end
  let :child do Class.new Mithril::Controllers::AbstractController; end
  let :proxy_instance do proxy.new request; end
  let :child_instance do child.new request; end
  let :proxy_action do FactoryGirl.generate :action_key; end
  let :child_action do FactoryGirl.generate :action_key; end
  let :proxy_command do proxy_action.to_s.gsub('_', ' '); end
  let :child_command do child_action.to_s.gsub('_', ' '); end
  
  before :each do
    proxy.define_action proxy_action do |session, arguments|; "proxy command"; end
    child.define_action child_action do |session, arguments|; "child command"; end
  end # before each
  
  let :session   do {}; end
  let :arguments do []; end
  
  specify { expect(proxy_instance).to have_action proxy_action }
  specify { expect(child_instance).to have_action child_action }
  specify { expect(proxy_instance).not_to have_action child_action }
  
  describe :allow_own_actions_while_proxied? do
    specify { expect(proxy_instance).to respond_to(:allow_own_actions_while_proxied?).
      with(0).arguments }
  end # describe
  
  describe :proxy do
    specify { expect(proxy_instance).to respond_to(:proxy).with(0).arguments }
    specify { expect(proxy_instance.proxy).to be_a [Mithril::Controllers::AbstractController, nil] }
  end # describe proxy
  
  describe :commands do
    specify { expect(proxy_instance.commands).to include proxy_command }
    specify { expect(proxy_instance.commands).not_to include child_command }
  end # describe
  
  describe :has_command? do
    specify { expect(proxy_instance).to have_command proxy_command }
    specify { expect(proxy_instance).not_to have_command child_command }
  end # describe
  
  describe :can_invoke? do
    specify { expect(proxy_instance.can_invoke? proxy_command).to be true }
    specify { expect(proxy_instance.can_invoke? child_command).to be false }
  end # describe
  
  describe :can_invoke_on_self? do
    specify { expect(proxy_instance).to respond_to(:can_invoke_on_self?).
      with(1).arguments }
    specify { expect(proxy_instance.can_invoke_on_self? proxy_command).to be true }
    specify { expect(proxy_instance.can_invoke_on_self? child_command).to be false }
  end # describe
  
  describe :invoke_command do
    specify { expect(proxy_instance.invoke_command proxy_command).to eq "proxy command" }
  end # describe
  
  context "with a proxy subject defined" do
    before :each do proxy_instance.stub :proxy do child_instance; end; end
    
    specify { expect(proxy_instance.proxy).to be child_instance }
    
    specify { expect(proxy_instance.commands).to include child_command }
    
    specify { expect(proxy_instance).to have_command child_command }
    
    specify { expect(proxy_instance.can_invoke? child_command).to be true }
    
    specify { expect(proxy_instance.can_invoke_on_self? child_command).to be false }
    
    specify { expect(proxy_instance.invoke_command child_command).to eq "child command" }
    
    context "allowing own actions" do
      before :each do proxy_instance.stub :allow_own_actions_while_proxied? do true; end; end
      
      specify { expect(proxy_instance.allow_own_actions_while_proxied?).to be true }
      
      specify { expect(proxy_instance.commands).to include proxy_command }

      specify { expect(proxy_instance).to have_command proxy_command }

      specify { expect(proxy_instance.can_invoke? proxy_command).to be true }

      specify { expect(proxy_instance.invoke_command proxy_command).to eq "proxy command" }
    end # context

    context "allowing own actions" do
      before :each do proxy_instance.stub :allow_own_actions_while_proxied? do false; end; end

      specify { expect(proxy_instance.allow_own_actions_while_proxied?).to be false }

      specify { expect(proxy_instance.commands).not_to include proxy_command }

      specify { expect(proxy_instance).not_to have_command proxy_command }

      specify { expect(proxy_instance.can_invoke? proxy_command).to be false }

      specify { expect(proxy_instance.invoke_command proxy_command).to match /don't know how/i }
    end # context
  end # context
end # shared examples
