require "spec_helper"

describe AttrExtras::AttrInitialize::ExtractHashDefaultValues, "#call" do
  it "extracts hash arguments and their default values" do
    names = [:foo, :fuu, [:bar, :bor, {:baz=>"WOW", :victor=>"arias"}]]

    extracted_names, default_values = extract(names)

    extracted_names.must_equal [ :foo, :fuu, [ :bar, :bor, :baz, :victor ]]
    default_values.must_equal baz: "WOW", victor: "arias"
  end

  it "does not crash when there is no hash argument" do
    no_hash_argument = [ :foo, :bar ]

    extracted_names, default_values = extract(no_hash_argument)

    extracted_names.must_equal [ :foo, :bar ]
    default_values.must_equal {}
  end

  def extract(names)
    AttrExtras::AttrInitialize::ExtractHashDefaultValues.call(names)
  end
end
