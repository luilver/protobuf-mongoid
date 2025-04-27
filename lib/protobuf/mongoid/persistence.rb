# frozen_string_literal: true

module Protobuf
  module Mongoid
    # Persistence methods
    module Persistence
      extend ::ActiveSupport::Concern

      ##
      # Class Methods
      #
      module ClassMethods
        # :nodoc:
        def create(attributes = {}, &block)
          attributes = attributes_from_proto(attributes) if attributes.is_a?(::Protobuf::Message)

          super(attributes, &block)
        end

        # :nodoc:
        def create!(attributes = {}, &block)
          attributes = attributes_from_proto(attributes) if attributes.is_a?(::Protobuf::Message)

          super(attributes, &block)
        end
      end

      # Override Mongoid's initialize method so it can accept a protobuf
      # message as it's attributes.
      # :noapi:
      def initialize(*args, &block)
        args[0] = attributes_from_proto(args.first) if args.first.is_a?(::Protobuf::Message)
        super(*args, &block)
      end

      # :nodoc:
      def assign_attributes(attributes)
        attributes = attributes_from_proto(attributes) if attributes.is_a?(::Protobuf::Message)

        super(attributes)
      end

      # :nodoc:
      def update(attributes)
        attributes = attributes_from_proto(attributes) if attributes.is_a?(::Protobuf::Message)

        super(attributes)
      end

      # :nodoc:
      def update!(attributes)
        attributes = attributes_from_proto(attributes) if attributes.is_a?(::Protobuf::Message)

        super(attributes)
      end
    end
  end
end
