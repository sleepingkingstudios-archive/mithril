# lib/mithril/controllers/proxy_controller.rb

require 'mithril/controllers/abstract_controller'

module Mithril::Controllers
  # Redirects incoming commands to a proxy controller based on the :proxy
  # method. If no proxy is present, evaluates commands as normal.
  class ProxyController < AbstractController
    # The subject controller to which commands are redirected. Must be
    # overriden in subclasses.
    # 
    # @return [AbstractController]
    def proxy
      nil # override this in sub-classes
    end # method proxy
    
    def allow_empty_action?
      if proxy.nil?
        super
      elsif self.allow_own_actions_while_proxied?
        super || proxy.allow_empty_action?
      else
        proxy.allow_empty_action?
      end # if-elsif-else
    end # method allow_empty_action
    
    # If evalutes to true, then any actions defined on this controller will be
    # available even when a proxy is present. Defaults to true, but can be
    # overriden in subclasses.
    #
    # @return [Boolean]
    def allow_own_actions_while_proxied?
      true
    end # method allow_own_actions_while_proxied?
    
    # @see AbstractController#commands
    def commands
      if proxy.nil?
        super
      elsif self.allow_own_actions_while_proxied?
        super + proxy.commands
      else
        proxy.commands
      end # if-elsif-else
    end # method commands
    
    # @see AbstractController#can_invoke?
    alias_method :can_invoke_on_self?, :can_invoke?
    
    # As can_invoke?, but returns true iff the command is available on this
    # controller directly, as opposed to through a proxy subject.
    # 
    # @param [String]
    # @return [Boolean]
    # @see ProxyController#can_invoke_on_self?
    def can_invoke?(input)
      if self.proxy.nil?
        super
      elsif self.allow_own_actions_while_proxied? && self.can_invoke_on_self?(input)
        super
      else
        proxy.can_invoke?(input)
      end # if-elsif-else
    end # method can_invoke_on_self?
    
    # If no proxy is present, attempts to invoke the command on self. If a
    # proxy subject is present and the parent can invoke that command and
    # allow_own_actions_while_proxied? evaluates to true, attempts to invoke
    # the command on self. Otherwise, if the proxy subject can invoke that
    # command, invokes the command on the proxy subject.
    # 
    # This precedence order was selected to allow reflection within commands,
    # e.g. the help action in Mixins::HelpActions that lists all available
    # commands.
    # 
    # @param [Object] input The input to be parsed and evaluated. Type and
    #   format will depend on the parser used.
    # @return [Object] The result of the command. If no command is found,
    #   returns the result of command_missing.
    # @see #proxy
    # @see AbstractController#invoke_command
    def invoke_command(input)
      # Mithril.logger.debug "#{class_name}.invoke_command(), text =" +
      #   " #{text.inspect}, session = #{request.session.inspect}, proxy =" +
      #   " #{proxy}"
      
      if self.proxy.nil?
        super
      elsif self.allow_own_actions_while_proxied? && self.can_invoke_on_self?(input)
        super
      elsif proxy.can_invoke? input
        proxy.invoke_command input
      else
        command_missing(input)
      end # if-elsif-else
    end # method invoke_command
  end # class ProxyController
end # module

