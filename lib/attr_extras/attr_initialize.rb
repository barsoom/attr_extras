class AttrInitialize
  def initialize(klass, names)
    @klass, @names = klass, names
  end

  def apply
    names = @names

    min_arity = names.count { |n| not n.is_a?(Array) }
    max_arity = names.length

    @klass.send(:define_method, :initialize) do |*values|
      provided_arity = values.length

      unless (min_arity..max_arity).include?(provided_arity)
        arity_range = [min_arity, max_arity].uniq.join("..")
        raise ArgumentError, "wrong number of arguments (#{provided_arity} for #{arity_range})"
      end

      names.zip(values).each do |name_or_names, value|
        if name_or_names.is_a?(Array)
          value ||= {}

          name_or_names.each do |name|
            if name.to_s.end_with?("!")
              actual_name = name.to_s.chop.to_sym
              actual_value = value.fetch(actual_name)
            else
              actual_name = name
              actual_value = value[name]
            end

            instance_variable_set("@#{actual_name}", actual_value)
          end
        else
          name = name_or_names
          instance_variable_set("@#{name}", value)
        end
      end
    end
  end
end
