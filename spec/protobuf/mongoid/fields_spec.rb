require "spec_helper"

describe Protobuf::Mongoid::Fields do
  describe "._protobuf_map_fields" do
    context "when the class has a document" do
      let(:expected_field_names) {
        User.fields.inject({}) do |hash, field|
          hash[field[1].name.to_sym] = field
          hash
        end
      }

      let(:expected_field_types) {
        User.fields.inject({}) do |hash, field|
          hash[field[1].options[:type].to_s.to_sym] ||= ::Set.new
          hash[field[1].options[:type].to_s.to_sym] << field[1].name.to_sym
          hash
        end
      }
      
      it "maps fields by name" do
        expect(User._protobuf_fields).to eq expected_field_names
      end

      it "maps field names by field type" do
        expected_field_types.each do |expected_field_type, value|
          expect(User._protobuf_field_types).to include expected_field_type => value
        end
      end
    end
  end

  context "field type predicates" do
    before { allow(User).to receive(:_protobuf_field_types).and_return({}) }

    describe "._protobuf_date_field?" do
      before { User._protobuf_field_types[:date] = [:foo_date] }

      context "when the field type is :date" do
        it "is true" do
          expect(User._protobuf_date_field?(:foo_date)).to be true
        end
      end

      context "when the field type is not :date" do
        it "is false" do
          expect(User._protobuf_date_field?(:bar_date)).to be false
        end
      end
    end

    describe "._protobuf_datetime_field?" do
      before { User._protobuf_field_types[:datetime] = [:foo_datetime] }

      context "when the field type is :datetime" do
        it "is true" do
          expect(User._protobuf_datetime_field?(:foo_datetime)).to be true
        end
      end

      context "when the field type is not :datetime" do
        it "is false" do
          expect(User._protobuf_datetime_field?(:bar_datetime)).to be false
        end
      end
    end

    describe "._protobuf_time_field?" do
      before { User._protobuf_field_types[:time] = [:foo_time] }

      context "when the field type is :time" do
        it "is true" do
          expect(User._protobuf_time_field?(:foo_time)).to be true
        end
      end

      context "when the field type is not :time" do
        it "is false" do
          expect(User._protobuf_time_field?(:bar_time)).to be false
        end
      end
    end

    describe "._protobuf_timestamp_field?" do
      before { User._protobuf_field_types[:timestamp] = [:foo_timestamp] }

      context "when the field type is :timestamp" do
        it "is true" do
          expect(User._protobuf_timestamp_field?(:foo_timestamp)).to be true
        end
      end

      context "when the field type is not :timestamp" do
        it "is false" do
          expect(User._protobuf_timestamp_field?(:bar_timestamp)).to be false
        end
      end
    end
  end
end
