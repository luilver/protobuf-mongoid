# frozen_string_literal: true

require 'spec_helper'

describe Protobuf::Mongoid::NestedAttributes do
  let(:user_message) do
    UserMessage.new(name: 'foo bar', email: 'foo@test.co', photos: [{ url: 'https://test.co/test.png' }])
  end

  describe '._filter_attribute_fields', aggregate_failures: true do
    it 'includes nested attributes' do
      attribute_fields = User._filter_attribute_fields(user_message)
      expect(attribute_fields[:photos_attributes]).to eq(user_message.photos)
    end
  end

  # TODO: This test is not working as expected. It should be fixed.
  # NoMethodError:
  #     undefined method `with_indifferent_access' for 'https://test.co/test.png':String
  describe '.new' do
    context 'when a model accepts nested attributes' do
      xit 'transforms nested attributes', aggregate_failures: true do
        user_message.photos.each do |photo_message|
          expect(Photo).to receive(:attributes_from_proto).with(photo_message).and_call_original
        end
        User.new(user_message)
      end
    end
  end
end
