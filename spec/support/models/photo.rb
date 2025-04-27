# frozen_string_literal: true

class Photo
  include ::Mongoid::Document
  include ::Protobuf::Mongoid::Model
end