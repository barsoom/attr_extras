require "attr_extras/version"

module AttrExtras
  module ClassMethods
    def attr_initialize(*names)
      define_method(:initialize) do |*values|
        unless values.length == names.length
          raise ArgumentError, "wrong number of arguments (#{values.length} for #{names.length})"
        end

        names.zip(values).each do |name_or_names, value|
          if name_or_names.is_a?(Array)
            name_or_names.each do |key|
              instance_variable_set("@#{key}", value[key])
            end
          else
            instance_variable_set("@#{name_or_names}", value)
          end
        end
      end
    end

    def attr_private(*names)
      attr_reader(*names)
      private(*names)
    end

    def pattr_initialize(*names)
      attr_initialize(*names)
      attr_private(*names.flatten)
    end

    def method_object(method_name, *names)
      singleton_class.send(:define_method, method_name) do |*values|
        new(*values).send(method_name)
      end

      pattr_initialize(*names)
    end

    def attr_query(*names)
      attr_query_with_suffix(*names, "")
    end

    def attr_id_query(*names)
      attr_query_with_suffix(*names, "_id")
    end

    private

    def attr_query_with_suffix(*names, suffix)
      names.each do |name|
        name = name.to_s

        raise "#{__method__} wants `#{name}?`, not `#{name}`." unless name.end_with?("?")

        define_method(name) do             # def foo?
          !!send("#{name.chop}#{suffix}")  #   !!send("foo_id")
        end                                # end
      end
    end
  end
end

class Class
  include AttrExtras::ClassMethods
end
