require "attr_extras/version"
require "attr_extras/attr_initialize"
require "attr_extras/attr_query"
require "attr_extras/utils"

module AttrExtras
  module ModuleMethods
    def attr_initialize(*names)
      AttrInitialize.new(self, names).apply
    end

    def attr_private(*names)
      # Need this to avoid "private attribute?" warnings when running
      # the full test suite; not sure why exactly.
      public

      attr_reader(*names)
      private(*names)
    end

    def attr_value(*names)
      attr_reader(*names)

      define_method(:==) do |other|
        return false unless other.is_a?(self.class)

        names.all? { |attr| self.public_send(attr) == other.public_send(attr) }
      end

      # Both #eql? and #hash are required for hash identity.

      alias_method :eql?, :==

      define_method(:hash) do
        [self.class, *names.map { |attr| public_send(attr) }].hash
      end
    end

    def pattr_initialize(*names)
      attr_initialize(*names)
      attr_private(*Utils.flat_names(names))
    end

    def vattr_initialize(*names)
      attr_initialize(*names)
      attr_value(*Utils.flat_names(names))
    end

    def method_object(method_name, *names)
      define_singleton_method(method_name) do |*values|
        new(*values).public_send(method_name)
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

class Module
  include AttrExtras::ModuleMethods
end
