require "spec_helper"

describe AttrExtras::AttrInitialize::AttributesDeclaration do
  it "handles positional attributes with hash attributes and default values" do
    names = [ :foo, :fuu, [ :bar, :bor, { :baz => "WOW", :victor => "arias" } ]]

    attributes = AttrExtras::AttrInitialize::AttributesDeclaration.new(names)

    attributes.positional_attributes.must_equal [ :foo, :fuu ]
    attributes.hash_attributes.must_equal [ :bar, :bor, :baz, :victor ]
    attributes.default_values.must_equal baz: "WOW", victor: "arias"
  end

  it "handles positional attributes with hash attributes without default values" do
    names = [ :foo, :fuu, [ :bar, :bor ]]

    attributes = AttrExtras::AttrInitialize::AttributesDeclaration.new(names)

    attributes.positional_attributes.must_equal [ :foo, :fuu ]
    attributes.hash_attributes.must_equal [ :bar, :bor ]
    attributes.default_values.must_be_empty
  end

  it "handles just positional attributes" do
    no_hash_attribute = [ :foo, :bar ]

    attributes = AttrExtras::AttrInitialize::AttributesDeclaration.new(no_hash_attribute)

    attributes.positional_attributes.must_equal [ :foo, :bar ]
    attributes.hash_attributes.must_be_empty
    attributes.default_values.must_be_empty
  end

  it "handles just hash attributes" do
    just_hash_attributes = [[ :foo, :bar ]]

    attributes = AttrExtras::AttrInitialize::AttributesDeclaration.new(just_hash_attributes)

    attributes.positional_attributes.must_be_empty
    attributes.hash_attributes.must_equal [ :foo, :bar ]
    attributes.default_values.must_be_empty
  end

  it "handles just hash attributes with default values" do
    just_hash_attributes_with_default_values = [[ foo: "bar", wow: "uhu" ]]

    attributes = AttrExtras::AttrInitialize::AttributesDeclaration.new(just_hash_attributes_with_default_values)

    attributes.positional_attributes.must_be_empty
    attributes.hash_attributes.must_equal [ :foo, :wow ]
    attributes.default_values.must_equal foo: "bar", wow: "uhu"
  end

  it "raises when there is a positional attribute after the hash attributes" do
    invalid_attribute_names = [ :foo, [ :bar ], :baz ]

    attributes = AttrExtras::AttrInitialize::AttributesDeclaration.new(invalid_attribute_names)

    lambda { attributes.positional_attributes }.must_raise AttrExtras::InvalidParameterDeclaration
  end
end
