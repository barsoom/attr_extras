# encoding: utf-8

require "set"
require_relative "spec_helper"

describe Object, ".attr_value" do
  it "creates public readers" do
    klass = Class.new do
      attr_value :foo, :bar
    end

    example = klass.new
    example.instance_variable_set("@foo", "Foo")
    example.foo.must_equal "Foo"
    lambda { example.foo = "new value" }.must_raise NoMethodError
  end

  it "defines equality based on the attributes" do
    klass = Class.new do
      attr_initialize :foo, :bar
      attr_value :foo, :bar
    end

    example1 = klass.new("Foo", "Bar")
    example2 = klass.new("Foo", "Bar")
    example3 = klass.new("Arroz", "Feijão")

    assert example1 == example2, "Examples should be equal"
    refute example1 != example2, "Examples should be equal"

    refute example1 == example3, "Examples should not be equal"
    assert example1 != example3, "Examples should not be equal"
  end

  it "defines equality based on the actual type" do
    klass1 = Class.new do
      attr_initialize :foo
      attr_value :foo
    end
    klass2 = Class.new do
      attr_initialize :foo
      attr_value :foo
    end

    example1 = klass1.new("Foo")
    example2 = klass2.new("Foo")

    assert example1 != example2, "Examples should not be equal"
    refute example1 == example2, "Examples should not be equal"
  end

  it "considers an instance equal to itself" do
    klass = Class.new do
      attr_initialize :foo
      attr_value :foo
    end

    instance = klass.new("Foo")

    assert instance == instance, "Instance should be equal to itself"
  end

  it "can compare value objects to other kinds of objects" do
    klass = Class.new do
      attr_initialize :foo
      attr_value :foo
    end

    instance = klass.new("Foo")

    assert instance != "a string"
  end

  it "hashes objects the same if they have the same attributes" do
    klass = Class.new do
      attr_initialize :foo
      attr_value :foo
    end
    klass2 = Class.new do
      attr_initialize :foo
      attr_value :foo
    end

    example1 = klass.new("Foo")
    example2 = klass.new("Foo")
    example3 = klass.new("Bar")
    example4 = klass2.new("Foo")

    example1.hash.must_equal example2.hash
    example1.hash.wont_equal example3.hash
    example1.hash.wont_equal example4.hash

    assert example1.eql?(example2), "Examples should be 'eql?'"
    refute example1.eql?(example3), "Examples should not be 'eql?'"
    refute example1.eql?(example4), "Examples should not be 'eql?'"

    Set[example1, example2, example3, example4].length.must_equal 3

    hash = {}
    hash[example1] = :awyeah
    hash[example3] = :wat
    hash[example4] = :nooooo
    hash[example2].must_equal :awyeah
  end
end
