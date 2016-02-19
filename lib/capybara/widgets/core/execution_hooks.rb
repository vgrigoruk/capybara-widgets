module ExecutionHooks
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    # this method is invoked whenever a new instance method is added to a class
    def method_added(method_name)
      # do nothing if the method that was added was an actual hook method, or
      # if it already had hooks added to it
      return if hooks.include?(method_name) || ignored_methods.include?(method_name) || hooked_methods.include?(method_name)
      add_hooks_to(method_name)
    end

    # this is the DSL method that classes use to add before hooks
    def before_hook(method_name, opts={})
      hooks << method_name
      ignored_methods.concat Array(opts[:ignore])
    end

    # keeps track of all before hooks
    def hooks
      @hooks ||= []
    end

    # keeps track of all before hooks
    def ignored_methods
      @ignored_methods ||= []
    end

    private

    # keeps track of all currently hooked methods
    def hooked_methods
      @hooked_methods ||= []
    end

    def add_hooks_to(method_name)
      # add this method to known hook mappings to avoid infinite
      # recursion when we redefine the method below
      hooked_methods << method_name

      # grab the original method definition
      original_method = instance_method(method_name)

      # re-define the method, but notice how we reference the original
      # method definition
      define_method(method_name) do |*args, &block|
        # invoke the hook methods
        hooks_to_run = []
        klass = self.class
        while klass != BasicObject do
          hooks_to_run.concat(klass.hooks) if klass.respond_to? :hooks
          klass = klass.superclass
        end
        hooks_to_run.each do |h|
          # LOGGER.debug "calling hook #{h} for method: #{method_name}"
          method(h).call
        end

        # now invoke the original method
        original_method.bind(self).call(*args, &block)
      end
    end
  end
end
