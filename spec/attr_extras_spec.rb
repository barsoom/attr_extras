require "minitest/autorun"
require "minitest/pride"
require "attr_extras"

class Example
  attr_initialize :foo, :bar
  attr_private :foo, :bar
end

class PattrExample
  pattr_initialize :foo, :bar
end

class QueryExample
  attr_id_query :baz?, :boink?
  attr_accessor :baz_id
end

class MethodObjectExample
  method_object :fooable?,
    :foo

  def fooable?
    foo
  end
end

class ExampleWithHash
  pattr_initialize :foo, [:bar, :baz]
end

describe Object, ".method_object" do
  it "creates a class method that instantiates and runs that instance method" do
    assert MethodObjectExample.fooable?(true)
    refute MethodObjectExample.fooable?(false)
  end
end

describe Object, ".attr_initialize" do
  it "creates an initializer setting those instance variables" do
    example = Example.new("Foo", "Bar")
    example.instance_variable_get("@foo").must_equal "Foo"
    example.instance_variable_get("@bar").must_equal "Bar"
  end

  it "requires all arguments" do
    lambda { Example.new("Foo") }.must_raise ArgumentError
  end

  it "can set ivars from a hash" do
    example = ExampleWithHash.new("Foo", bar: "Bar", baz: "Baz")
    example.instance_variable_get("@foo").must_equal "Foo"
    example.instance_variable_get("@bar").must_equal "Bar"
    example.instance_variable_get("@baz").must_equal "Baz"
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

describe Object, ".pattr_initialize" do
  it "creates both initializer and private readers" do
    example = PattrExample.new("Foo", "Bar")
    example.send(:foo).must_equal "Foo"
  end

  it "works with hash ivars" do
    example = ExampleWithHash.new("Foo", bar: "Bar")
    example.send(:bar).must_equal "Bar"
  end
end

describe Object, ".attr_id_query" do
  it "creates id query methods" do
    example = QueryExample.new
    refute example.baz?
    example.baz_id = 123
    assert example.baz?
  end

  it "requires a trailing questionmark" do
    lambda { Object.attr_id_query(:foo) }.must_raise RuntimeError
  end
end
