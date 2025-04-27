# frozen_string_literal: true

module Protobuf
  module Mongoid
    # Transformer class
    class Transformer
      attr_accessor :callable, :options

      def initialize(callable, options = {})
        @callable = callable
        @options = options
      end

      def call(proto)
        return unless proto
        return unless proto.respond_to?(:call)

        callable.call
      end

      def nullify?(proto)
        return false unless options[:nullify_on]
        return false unless proto.field?(:nullify) && proto.nullify.is_a?(Array)
        return false if proto.nullify.empty?

        proto.nullify.include?(options[:nullify_on].to_s)
      end
    end
  end
end
