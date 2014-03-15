require "attr_extras/version"
require "attr_extras/attr_initialize"

module AttrExtras
  module ClassMethods
    def attr_initialize(*names)
      AttrInitialize.new(self, names).apply
    end

    def attr_private(*names)
      attr_reader(*names)
      private(*names)
    end

    def pattr_initialize(*names)
      attr_initialize(*names)
      attr_private *attr_flat_names(names)
    end

    def vattr_initialize(*names)
      attr_initialize(*names)
      attr_value *attr_flat_names(names)
    end

    def attr_value(*names)
      attr_reader *names

      define_method(:==) do |other|
        return false unless other.is_a?(self.class)

        names.all? { |attr| self.public_send(attr) == other.public_send(attr) }
      end
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

    def attr_flat_names(names)
      names.flatten.map { |x| x.to_s.sub(/!\z/, "") }
    end

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
