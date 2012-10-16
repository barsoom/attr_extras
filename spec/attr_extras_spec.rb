require "minitest/autorun"
require "attr_extras"

class Example
  attr_init :foo, :bar
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
