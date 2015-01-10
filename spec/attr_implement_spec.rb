require_relative "spec_helper"

describe Object, ".attr_implement" do
  it "creates 0-argument methods that raise" do
    klass = Class.new do
      attr_implement :foo, :bar
    end

    example = klass.new
    exception = lambda { example.foo }.must_raise RuntimeError
    exception.message.must_equal "Implement a 'foo()' method"
  end

  it "allows specifying arity and argument names" do
    klass = Class.new do
      attr_implement :foo, [:name, :age]
    end

    example = klass.new

    exception = lambda { example.foo(1, 2) }.must_raise RuntimeError
    exception.message.must_equal "Implement a 'foo(name, age)' method"

    lambda { example.foo }.must_raise ArgumentError
  end

  it "does not raise if method is implemented in a subclass" do
    klass = Class.new do
      attr_implement :foo
    end

    subklass = Class.new(klass) do
      def foo
        "bar"
      end
    end

    subklass.new.foo.must_equal "bar"
  end

  # E.g. Active Record defines column query methods like "admin?"
  # higher up in the ancestor chain.
  it "does not raise if method is implemented in a superclass" do
    superklass = Class.new do
      def foo
        "bar"
      end
    end

    klass = Class.new(superklass) do
      attr_implement :foo
    end

    klass.new.foo.must_equal "bar"
  end
end
