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

    def attr_id_query(*names)
      names.each do |name|
        name = name.to_s

        raise "#{__method__} wants `#{name}?`, not `#{name}`." unless name.end_with?("?")

        define_method(name) do            # def foo?
          !!send("#{name.chop}_id")  #   !!send("foo_id")
        end                               # end
      end
    end
  end
end

Object.extend AttrExtras::ClassMethods
