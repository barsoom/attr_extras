require "spec_helper"

describe Object, ".aattr_initialize" do
  it "creates an initializer and public readers" do
    klass = Class.new do
      aattr_initialize :foo, :bar
    end

    example = klass.new("Foo", "Bar")

    _(example.foo).must_equal "Foo"
  end

  it "creates public writers" do
    klass = Class.new do
      aattr_initialize :foo, :bar
    end

    example = klass.new("Foo", "Bar")
    example.foo = "Baz"

    _(example.foo).must_equal "Baz"
  end

  it "works with hash ivars" do
    klass = Class.new do
      aattr_initialize :foo, [ :bar, :baz! ]
    end

    example = klass.new("Foo", bar: "Bar", baz: "Baz")

    _(example.baz).must_equal "Baz"
  end

  it "works with hash ivars and default values" do
    klass = Class.new do
      aattr_initialize :foo, [ bar: "Bar", baz!: "Baz" ]
    end

    example = klass.new("Foo")

    _(example.baz).must_equal "Baz"
  end

  it "accepts a block for initialization" do
    klass = Class.new do
      aattr_initialize :value do
        @copy = @value
      end

      attr_reader :copy
    end

    example = klass.new("expected")

    _(example.copy).must_equal "expected"
  end

  it "accepts the alias attr_accessor_initialize" do
    klass = Class.new do
      attr_accessor_initialize :foo, :bar
    end

    example = klass.new("Foo", "Bar")

    _(example.foo).must_equal "Foo"
  end
end
