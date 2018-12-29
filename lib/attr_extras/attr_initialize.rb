class AttrExtras::AttrInitialize
  def initialize(klass, names, block)
    @klass, @names, @block = klass, names, block
  end

  attr_reader :klass, :names
  private :klass, :names

  def apply
    # The define_method block can't call our methods, so we need to make
    # things available via local variables.
    block = @block
    default_values_var = default_values
    positional_args_var = positional_args

    validate_arity = method(:validate_arity)
    validate_args = method(:validate_args)

    klass.send(:define_method, :initialize) do |*values|
      hash_values = values.select { |name| name.is_a?(Hash) }.inject(:merge) || {}

      validate_arity.call(values.length, self.class)
      validate_args.call(values, hash_values)

      default_values_var.each do |name, default_value|
        instance_variable_set("@#{name}", default_value)
      end

      positional_args_var.zip(values).each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      hash_values.each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      if block
        instance_eval(&block)
      end
    end
  end

  private

  def positional_args
    @positional_args ||= names.take_while { |name| !name.is_a?(Array) }
  end

  def default_values
    @default_values ||= begin
      default_values_hash = names.flatten.select { |name| name.is_a?(Hash) }.inject(:merge) || {}
      default_values_hash.transform_keys { |name| name.to_s.sub(/!\z/, "").to_sym }
    end
  end

  def hash_args
    @hash_args ||= (names - positional_args).flatten.map { |name|
      name.is_a?(Hash) ? name.keys : name
    }.flatten
  end

  def hash_args_names
    @hash_args_names ||= hash_args.map { |name| name.to_s.sub(/!\z/, "").to_sym }
  end

  def hash_args_required
    @hash_args_required ||= hash_args.select { |name| name.to_s.end_with?("!") }
      .map { |name| name.to_s.chop.to_sym }
  end

  def validate_arity(provided_arity, klass)
    arity_without_hashes = names.count { |name| not name.is_a?(Array) }
    arity_with_hashes    = names.length

    unless (arity_without_hashes..arity_with_hashes).include?(provided_arity)
      arity_range = [ arity_without_hashes, arity_with_hashes ].uniq.join("..")
      raise ArgumentError, "wrong number of arguments (#{provided_arity} for #{arity_range}) for #{klass.name} initializer"
    end
  end

  def validate_args(values, hash_values)
    hash_values = values.select { |n| n.is_a?(Hash) }.inject(:merge) || {}
    unknown_keys = hash_values.keys - hash_args_names
    if unknown_keys.any?
      raise ArgumentError, "Got unknown keys: #{unknown_keys.inspect}; allowed keys: #{hash_args_names.inspect}"
    end

    missing_args = hash_args_required - hash_values.keys - default_values.keys
    if missing_args.any?
      raise KeyError, "Missing required keys: #{missing_args.inspect}"
    end
  end
end
