require "attr_extras/version"

module AttrExtras
  module ClassMethods
    def attr_initialize(*names)
      define_method(:initialize) do |*values|
        unless values.length == names.length
          raise ArgumentError, "wrong number of arguments (#{values.length} for #{names.length})"
        end

        names.zip(values).each do |name, value|
          instance_variable_set("@#{name}", value)
        end
      end
    end

    def attr_private(*names)
      attr_reader *names
      private *names
    end
  end
end

Object.extend AttrExtras::ClassMethods
