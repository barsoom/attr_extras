require "spec_helper_without_loading_attr_extras"
require "attr_extras/explicit"

# Sanity check.
if String.respond_to?(:pattr_initialize)
  raise "Expected this test suite not to have AttrExtras mixed in!"
end

describe AttrExtras, "explicit mode" do
  it "must have methods mixed in explicitly" do
    has_methods_before_mixin = nil
    has_methods_after_mixin = nil

    Class.new do
      has_methods_before_mixin = respond_to?(:pattr_initialize)
      extend AttrExtras.mixin
      has_methods_after_mixin = respond_to?(:pattr_initialize)
    end

    refute has_methods_before_mixin
    assert has_methods_after_mixin
  end

  it "mixes in a version of static_facade which does not blow up when the class method is called with an empty hash" do
    klass = Class.new do
      extend AttrExtras.mixin

      static_facade :foo, :value

      def foo
      end
    end

    refute_raises_anything { klass.foo({}) }
  end

  it "mixes in a version of static_facade which does not emit warnings when the initializer is overridden with more keyword arguments" do
    superklass = Class.new do
      extend AttrExtras.mixin

      static_facade :something, [:foo!, :bar!]

      def something
      end
    end

    klass = Class.new(superklass) do
      def initialize(extra:, **rest)
        super(**rest)
        @extra = extra
      end
    end

    refute_warnings_emitted { klass.something(foo: 1, bar: 2, extra: 'yay') }
  end
end
