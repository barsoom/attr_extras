require "minitest/autorun"
require "attr_extras"

class Example
  attr_init :foo, :bar
  attr_private :foo, :bar
end

describe Object, ".attr_init" do
  it "creates an initializer setting those instance variables" do
    example = Example.new("Foo", "Bar")
    example.instance_variable_get("@foo").must_equal "Foo"
    example.instance_variable_get("@bar").must_equal "Bar"
  end

  it "requires all arguments" do
    lambda { Example.new("Foo") }.must_raise ArgumentError
  end
end

describe Object, ".attr_private" do
  it "creates private readers" do
    example = Example.new("Foo", "Bar")
    example.send(:foo).must_equal "Foo"
    example.send(:bar).must_equal "Bar"
    lambda { example.foo }.must_raise NoMethodError
  end
end
