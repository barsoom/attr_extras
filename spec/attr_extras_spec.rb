require_relative "spec_helper"

describe AttrExtras, "in modules" do
  it "is supported" do
    mod = Module.new do
      pattr_initialize :name
    end

    klass = Class.new do
      include mod
    end

    klass.new("Hello").send(:name).must_equal "Hello"
  end
end
