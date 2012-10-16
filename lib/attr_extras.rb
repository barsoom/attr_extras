require "attr_extras/version"

module AttrExtras
  module ClassMethods
    def attr_init(*keys)
      define_method(:initialize) do |*values|
        unless values.length == keys.length
          raise ArgumentError, "wrong number of arguments (#{values.length} for #{keys.length})"
        end

        keys.zip(values).each do |k, v|
          instance_variable_set("@#{k}", v)
        end
      end
    end
  end
end

Object.extend AttrExtras::ClassMethods
