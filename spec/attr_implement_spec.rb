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
end
