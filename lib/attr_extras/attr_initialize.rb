class AttrInitialize
  def initialize(klass, names)
    @klass, @names = klass, names
  end

  attr_reader :klass, :names
  private :klass, :names

  def apply
    # The define_method block can't call our methods, so we need to make
    # things available via local variables.
    names = @names
    validate_arity = method(:validate_arity)
    set_ivar_from_hash = method(:set_ivar_from_hash)

    klass.send(:define_method, :initialize) do |*values|
      validate_arity.call(values.length)

      names.zip(values).each do |name_or_names, value|
        if name_or_names.is_a?(Array)
          hash = value || {}

          name_or_names.each do |name|
            set_ivar_from_hash.call(self, name, hash)
          end
        else
          name = name_or_names
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end

  private

  def validate_arity(provided_arity)
    arity_without_hashes = names.count { |name| not name.is_a?(Array) }
    arity_with_hashes    = names.length

    unless (arity_without_hashes..arity_with_hashes).include?(provided_arity)
      arity_range = [arity_without_hashes, arity_with_hashes].uniq.join("..")
      raise ArgumentError, "wrong number of arguments (#{provided_arity} for #{arity_range})"
    end
  end

  def set_ivar_from_hash(instance, name, hash)
    if name.to_s.end_with?("!")
      actual_name = name.to_s.chop.to_sym
      value = hash.fetch(actual_name)
    else
      actual_name = name
      value = hash[name]
    end

    instance.instance_variable_set("@#{actual_name}", value)
  end
end
