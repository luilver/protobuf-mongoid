# frozen_string_literal: true

require 'protobuf/mongoid/attribute_methods'
require 'protobuf/mongoid/errors'
require 'protobuf/mongoid/fields'
require 'protobuf/mongoid/nested_attributes'
require 'protobuf/mongoid/persistence'
require 'protobuf/mongoid/scope'
require 'protobuf/mongoid/serialization'
require 'protobuf/mongoid/transformation'
require 'protobuf/mongoid/validations'

module Protobuf
  module Mongoid
    # Base for Protobuf-Mongoid models
    module Model
      extend ::ActiveSupport::Concern

      included do
        include Protobuf::Mongoid::AttributeMethods
        include Protobuf::Mongoid::Fields
        include Protobuf::Mongoid::NestedAttributes
        include Protobuf::Mongoid::Persistence
        include Protobuf::Mongoid::Serialization
        include Protobuf::Mongoid::Scope
        include Protobuf::Mongoid::Transformation
        include Protobuf::Mongoid::Validations
      end
    end
  end
end
