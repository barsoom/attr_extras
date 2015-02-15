class AttrExtras::AttrInitialize
  def initialize(klass, names, block)
    @klass, @names, @block = klass, names, block
  end

  attr_reader :klass, :names
  private :klass, :names

  def apply
    # The define_method block can't call our methods, so we need to make
    # things available via local variables.
    names = @names
    block = @block
    validate_arity = method(:validate_arity)
    set_ivar_from_args = method(:set_ivar_from_args)

    klass.send(:define_method, :initialize) do |*values|
      validate_arity.call(values.length, self.class)

      names.zip(values).each do |name_or_names, value|
        set_ivar_from_args.call(self, name_or_names, value)
      end

      if block
        instance_eval(&block)
      end
    end
  end

  private

  def validate_arity(provided_arity, klass)
    arity_without_hashes = names.count { |name| !name.is_a?(Array) && !name.is_a?(Hash) }
    arity_with_hashes    = names.length

    unless (arity_without_hashes..arity_with_hashes).include?(provided_arity)
      arity_range = [ arity_without_hashes, arity_with_hashes ].uniq.join("..")
      raise ArgumentError, "wrong number of arguments (#{provided_arity} for #{arity_range}) for #{klass.name} initializer"
    end
  end

  def set_ivar_from_args instance, args, value
    case args
    when Array
      hash = value || {}

      args.each do |array_value|
        value = case array_value
          when Hash
            array_value.merge!(hash)
            nil
          when /!\z/
            array_value = array_value.to_s.chop.to_sym
            hash.fetch(array_value)
          else
            hash[array_value]
          end

        set_ivar_from_args(instance, array_value, value)
      end
    when Hash
      args.each do |name, default_value|
        set_ivar_from_args(instance, name, value || default_value)
      end
    else
      instance.instance_variable_set("@#{args}", value)
    end
  end
end
