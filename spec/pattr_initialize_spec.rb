require_relative "spec_helper"

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
