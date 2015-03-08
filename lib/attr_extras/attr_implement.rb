class AttrExtras::AttrImplement
  def initialize(klass, names)
    @klass, @names = klass, names.dup
  end

  def apply
    arg_names = @names.last.is_a?(Array) ? @names.pop : []
    expected_arity = arg_names.length

    # Make available within the block.
    names = @names

    mod = Module.new do
      define_method :method_missing do |name, *args|
        if names.include?(name)
          provided_arity = args.length

          if provided_arity != expected_arity
            raise ArgumentError, "wrong number of arguments (#{provided_arity} for #{expected_arity})"
          end

          raise AttrExtras::MethodNotImplementedError, "Implement a '#{name}(#{arg_names.join(", ")})' method"
        else
          super(name, *args)
        end
      end
    end

    @klass.include(mod)
  end
end
