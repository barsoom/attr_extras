require "spec_helper"

describe AttrExtras::AttrInitialize::Attributes do
  it "handles positional arguments with hash arguments and default values" do
    names = [ :foo, :fuu, [ :bar, :bor, { :baz => "WOW", :victor => "arias" } ]]

    attributes = AttrExtras::AttrInitialize::Attributes.new(names)

    attributes.positional.must_equal [ :foo, :fuu ]
    attributes.hash.must_equal [ :bar, :bor, :baz, :victor ]
    attributes.default_values.must_equal baz: "WOW", victor: "arias"
  end

  it "handles positional arguments with hash arguments without default values" do
    names = [ :foo, :fuu, [ :bar, :bor ]]

    attributes = AttrExtras::AttrInitialize::Attributes.new(names)

    attributes.positional.must_equal [ :foo, :fuu ]
    attributes.hash.must_equal [ :bar, :bor ]
    attributes.default_values.must_be_empty
  end

  it "handles just positional arguments" do
    no_hash_argument = [ :foo, :bar ]

    attributes = AttrExtras::AttrInitialize::Attributes.new(no_hash_argument)

    attributes.positional.must_equal [ :foo, :bar ]
    attributes.hash.must_be_empty
    attributes.default_values.must_be_empty
  end

  it "handles just hash arguments" do
    just_hash_arguments = [[ :foo, :bar ]]

    attributes = AttrExtras::AttrInitialize::Attributes.new(just_hash_arguments)

    attributes.positional.must_be_empty
    attributes.hash.must_equal [ :foo, :bar ]
    attributes.default_values.must_be_empty
  end

  it "handles just hash arguments with default values" do
    just_hash_arguments_with_default_values = [[ foo: "bar", wow: "uhu" ]]

    attributes = AttrExtras::AttrInitialize::Attributes.new(just_hash_arguments_with_default_values)

    attributes.positional.must_be_empty
    attributes.hash.must_equal [ :foo, :wow ]
    attributes.default_values.must_equal foo: "bar", wow: "uhu"
  end

  it "raises when there is a positional argument after the hash arguments" do
    invalid_attribute_names = [ :foo, [ :bar ], :baz ]

    attributes = AttrExtras::AttrInitialize::Attributes.new(invalid_attribute_names)

    lambda { attributes.hash }.must_raise AttrExtras::InvalidParameterDeclaration
  end
end
