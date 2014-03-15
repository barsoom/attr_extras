require_relative "spec_helper"

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
