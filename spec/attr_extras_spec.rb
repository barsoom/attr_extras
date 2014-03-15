# encoding: utf-8

require "minitest/autorun"
require "minitest/pride"
require "attr_extras"

describe Object, ".method_object" do
  it "creates a class method that instantiates and runs that instance method" do
    klass = Class.new do
      method_object :fooable?,
        :foo

      def fooable?
        foo
      end
    end

    assert klass.fooable?(true)
    refute klass.fooable?(false)
  end

  it "doesn't require attributes" do
    klass = Class.new do
      method_object :fooable?

      def fooable?
        true
      end
    end

    assert klass.fooable?
  end
end

describe Object, ".attr_initialize" do
  let(:klass) do
    Class.new do
      attr_initialize :foo, :bar
    end
  end

  it "creates an initializer setting those instance variables" do
    example = klass.new("Foo", "Bar")
    example.instance_variable_get("@foo").must_equal "Foo"
    example.instance_variable_get("@bar").must_equal "Bar"
  end

  it "requires all arguments" do
    lambda { klass.new("Foo") }.must_raise ArgumentError
  end

  it "can set ivars from a hash" do
    klass = Class.new do
      attr_initialize :foo, [:bar, :baz]
    end

    example = klass.new("Foo", :bar => "Bar", :baz => "Baz")
    example.instance_variable_get("@foo").must_equal "Foo"
    example.instance_variable_get("@bar").must_equal "Bar"
    example.instance_variable_get("@baz").must_equal "Baz"
  end

  it "treats hash values as optional" do
    klass = Class.new do
      attr_initialize :foo, [:bar, :baz]
    end

    example = klass.new("Foo", :bar => "Bar")
    example.instance_variable_get("@baz").must_equal nil

    example = klass.new("Foo")
    example.instance_variable_get("@bar").must_equal nil
  end

  it "can require hash values" do
    klass = Class.new do
      attr_initialize [:optional, :required!]
    end

    example = klass.new(:required => "X")
    example.instance_variable_get("@required").must_equal "X"

    lambda { klass.new(:optional => "X") }.must_raise KeyError
  end
end

describe Object, ".attr_private" do
  let(:klass) do
    Class.new do
      attr_private :foo, :bar
    end
  end

  it "creates private readers" do
    example = klass.new
    example.instance_variable_set("@foo", "Foo")
    example.instance_variable_set("@bar", "Bar")
    example.send(:foo).must_equal "Foo"
    example.send(:bar).must_equal "Bar"
    lambda { example.foo }.must_raise NoMethodError
  end
end

describe Object, ".pattr_initialize" do
  it "creates both initializer and private readers" do
    klass = Class.new do
      pattr_initialize :foo, :bar
    end

    example = klass.new("Foo", "Bar")
    example.send(:foo).must_equal "Foo"
  end

  it "works with hash ivars" do
    klass = Class.new do
      pattr_initialize :foo, [:bar, :baz!]
    end

    example = klass.new("Foo", :bar => "Bar", :baz => "Baz")
    example.send(:baz).must_equal "Baz"
  end
end

describe Object, ".vattr_initialize" do
  it "creates initializer, value readers and value object identity" do
    klass = Class.new do
      vattr_initialize :foo, :bar
    end

    example1 = klass.new("Foo", "Bar")
    example2 = klass.new("Foo", "Bar")

    example1.foo.must_equal "Foo"
    example1.must_equal example2
  end

  it "works with hash ivars" do
    klass = Class.new do
      vattr_initialize :foo, [:bar, :baz!]
    end

    example1 = klass.new("Foo", :bar => "Bar", :baz => "Baz")
    example2 = klass.new("Foo", :bar => "Bar", :baz => "Baz")
    example1.baz.must_equal "Baz"
    example1.must_equal example2
  end
end

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
end

describe Object, ".attr_id_query" do
  it "creates id query methods" do
    klass = Class.new do
      attr_id_query :baz?, :boink?
      attr_accessor :baz_id
    end

    example = klass.new
    refute example.baz?

    example.baz_id = 123
    assert example.baz?
  end

  it "requires a trailing questionmark" do
    lambda { Object.attr_id_query(:foo) }.must_raise RuntimeError
  end
end

describe Object, ".attr_query" do
  it "creates attribute query methods" do
    klass = Class.new do
      attr_query :flurp?
      attr_accessor :flurp
    end

    example = klass.new
    refute example.flurp?
    example.flurp = "!"
    assert example.flurp?
  end

  it "requires a trailing questionmark" do
    lambda { Object.attr_query(:foo) }.must_raise RuntimeError
  end
end
