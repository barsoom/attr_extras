require "attr_extras/version"
require "attr_extras/attr_initialize"
require "attr_extras/attr_query"
require "attr_extras/utils"

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
      attr_private *Utils.flat_names(names)
    end

    def vattr_initialize(*names)
      attr_initialize(*names)
      attr_value *Utils.flat_names(names)
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
      AttrQuery.define_with_suffix(self, "", *names)
    end

    def attr_id_query(*names)
      AttrQuery.define_with_suffix(self, "_id", *names)
    end
  end
end

class Class
  include AttrExtras::ClassMethods
end
