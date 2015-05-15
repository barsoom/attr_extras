require "spec_helper"

describe AttrExtras::AttrInitialize::Attributes do
  it "handles plain arguments with hash arguments and default values" do
    names = [ :foo, :fuu, [ :bar, :bor, { :baz => "WOW", :victor => "arias" } ]]

    attributes = AttrExtras::AttrInitialize::Attributes.new(names)

    attributes.plain.must_equal [ :foo, :fuu ]
    attributes.hash.must_equal [ :bar, :bor, :baz, :victor ]
    attributes.default_values.must_equal baz: "WOW", victor: "arias"
  end

  it "handles just plain arguments" do
    no_hash_argument = [ :foo, :bar ]

    attributes = AttrExtras::AttrInitialize::Attributes.new(no_hash_argument)

    attributes.plain.must_equal [ :foo, :bar ]
    attributes.hash.must_be_empty
    attributes.default_values.must_be_empty
  end

  it "handles just hash arguments" do
    just_hash_arguments = [[ :foo, :bar ]]

    attributes = AttrExtras::AttrInitialize::Attributes.new(just_hash_arguments)

    attributes.plain.must_be_empty
    attributes.hash.must_equal [ :foo, :bar ]
    attributes.default_values.must_be_empty
  end

  it "handles just hash arguments with default values" do
    just_hash_arguments_with_default_values = [[ foo: "bar", wow: "uhu" ]]

    attributes = AttrExtras::AttrInitialize::Attributes.new(just_hash_arguments_with_default_values)

    attributes.plain.must_be_empty
    attributes.hash.must_equal [ :foo, :wow ]
    attributes.default_values.must_equal foo: "bar", wow: "uhu"
  end
end
