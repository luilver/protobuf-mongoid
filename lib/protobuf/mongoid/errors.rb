module Protobuf
  module Mongoid
    # = Protobuf Mongoid errors
    #
    # Generic Protobuf Mongoid exception class
    class ProtobufMongoidError < StandardError
    end

    # Raised by `attribute_from_proto` when the transformer method
    # given is not callable.
    class AttributeTransformerError < ProtobufMongoidError
      def message
        "Attribute transformers must be called with a callable or block!"
      end
    end

    # Raised by `field_from_document` when the convert method
    # given not callable.
    class FieldTransformerError < ProtobufMongoidError
      def message
        "Field transformers must be called with a callable or block!"
      end
    end

    # Raised by `to_proto` when no protobuf message is defined.
    class MessageNotDefined < ProtobufMongoidError
      attr_reader :class_name

      def initialize(klass)
        @class_name = klass.name
      end

      def message
        "#{class_name} does not define a protobuf message"
      end
    end

    # Raised by `field_scope` when given scope is not defined.
    class SearchScopeError < ProtobufMongoidError
    end

    # Raised by `upsert_scope` when a given scope is not defined
    class UpsertScopeError < ProtobufMongoidError
    end

    # Raised by `for_upsert` when no valid upsert_scopes are found
    class UpsertNotFoundError < ProtobufMongoidError
    end
  end
end
