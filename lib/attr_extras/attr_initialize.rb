require "attr_extras/attr_initialize/attributes"

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
    set_ivar_from_hash = method(:set_ivar_from_hash)

    attributes = Attributes.new(names)

    klass.send(:define_method, :initialize) do |*values|
      validate_arity.call(values.length, self.class)

      positional_attributes_values = values.take(attributes.positional.count)
      hash_attributes_values = values.drop(attributes.positional.count)

      attributes.positional.zip(positional_attributes_values).each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      hash_values_with_defaults = attributes.default_values.merge(hash_attributes_values.first || {})
      attributes.hash.each do |name|
        set_ivar_from_hash.call(self, name, hash_values_with_defaults)
      end

      if block
        instance_eval(&block)
      end
    end
  end

  private

  def validate_arity(provided_arity, klass)
    arity_without_hashes = names.count { |name| not name.is_a?(Array) }
    arity_with_hashes    = names.length

    unless (arity_without_hashes..arity_with_hashes).include?(provided_arity)
      arity_range = [ arity_without_hashes, arity_with_hashes ].uniq.join("..")
      raise ArgumentError, "wrong number of arguments (#{provided_arity} for #{arity_range}) for #{klass.name} initializer"
    end
  end

  def set_ivar_from_hash(instance, name, hash)
    if name.to_s.end_with?("!")
      actual_name = name.to_s.chop.to_sym
      value = hash.fetch(actual_name)
    else
      actual_name = name
      value = hash[actual_name]
    end

    instance.instance_variable_set("@#{actual_name}", value)
  end
end
