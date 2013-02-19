# lib/mithril/controllers/delegate_controller.rb

require 'mithril/controllers/abstract_controller'

module Mithril::Controllers
  # Delegation takes advantage of the fact that Mithril controllers exist on a
  # per-request basis. This allows us to modify the controller object based on
  # the current context, such as by defining new singleton actions or by mixing
  # in other modules which contain additional actions. The delegate controller
  # includes a helper methods for triggering delegate hooks from the controller
  # object.
  class DelegateController < AbstractController
    # Iterates through the given delegates and calls the :delegated_to hook on
    # each, providing the controller as an argument.
    # 
    # @params delegates
    def delegate_to(*delegates)
      delegates.each do |delegate|
        delegate.delegated_to(self) if delegate.respond_to? :delegated_to
      end # each
    end # method delegate_to
  end # class
end # module
