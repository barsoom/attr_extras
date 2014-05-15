require_relative "spec_helper"

describe Object, ".attr_implement" do
  it "creates methods that raise" do
    klass = Class.new do
      attr_implement :foo, :bar
    end

    example = klass.new
    exception = lambda { example.foo }.must_raise RuntimeError
    exception.message.must_equal "Implement a 'foo' method"
  end

  it "creates methods that accept any number of arguments" do
    klass = Class.new do
      attr_implement :foo
    end

    example = klass.new
    exception = lambda { example.foo(1, 2, 3) }.must_raise RuntimeError
    exception.message.must_equal "Implement a 'foo' method"
  end
end
