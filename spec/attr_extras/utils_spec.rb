require "spec_helper"

describe AttrExtras::Utils do
  describe "::flat_names" do
    subject { AttrExtras::Utils.flat_names(names) }

    describe "when pass list of arguments" do
      let(:names) { [:foo, :bar] }

      it { subject.must_equal ["foo", "bar"] }
    end

    describe 'whee pass hash ivars' do
      let(:names) { [:foo, [:bar, :baz!]] }

      it { subject.must_equal ["foo", "bar", "baz"] }
    end

    describe 'whee pass hash ivars with default values' do
      let(:names) { [:foo, [bar: "Bar", baz!: "Bar"]] }

      it { subject.must_equal ["foo", "bar", "baz"] }
    end
  end
end

