# lib/mithril/controllers/mixins/action_mixin.rb

require 'mithril/controllers/mixins'
require 'mithril/mixin'

module Mithril::Controllers::Mixins
  module ActionMixin
    include Mithril::Mixin
  
  private
    # Extends the mixin method to implement inheritance of @actions ivar.
    def mixin(source_module) # :doc:
      super
      
      self.mixins.each do |mixin|
        next unless source_module.respond_to? :actions
        if self.instance_variable_defined? :@actions
          source_module.actions.each do |key, value|
            @actions[key] = value
          end # each
        else
          @actions = source_module.actions.dup
        end # if-else
      end # each
    end # method mixin
  end # module
end # module
