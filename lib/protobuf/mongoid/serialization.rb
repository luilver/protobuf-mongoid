# frozen_string_literal: true

module Protobuf
  module Mongoid
    # Serialization methods
    module Serialization
      extend ActiveSupport::Concern

      included do
        class << self
          attr_writer :_protobuf_field_symbol_transformers,
                      :_protobuf_field_transformers,
                      :_protobuf_field_options,
                      :protobuf_message
        end
      end

      ##
      # Class Methods
      #
      module ClassMethods
        def _protobuf_field_objects
          @_protobuf_field_objects ||= {}
        end

        def _protobuf_field_options
          @_protobuf_field_options ||= {}
        end

        def _protobuf_field_symbol_transformers
          @_protobuf_field_symbol_transformers ||= {}
        end

        def _protobuf_field_transformers
          @_protobuf_field_transformers ||= {}
        end

        def _protobuf_message_deprecated_fields
          @_protobuf_message_deprecated_fields ||=
            protobuf_message.all_fields.map do |field|
              next if field.nil?
              next unless field.deprecated?

              field.name.to_sym
            end
        end

        def _protobuf_message_non_deprecated_fields
          @_protobuf_message_non_deprecated_fields ||=
            protobuf_message.all_fields.map do |field|
              next if field.nil?
              next if field.deprecated?

              field.name.to_sym
            end
        end

        def field_from_document(field, transformer = nil, &block)
          if transformer.is_a?(Symbol)
            _protobuf_field_symbol_transformers[field] = transformer
            return
          end

          transformer ||= block
          callable = transformer

          raise FieldTransformerError unless callable.respond_to?(:call)

          _protobuf_field_transformers[field.to_sym] = callable
        end

        def protobuf_fields(*fields)
          options = fields.extract_options!
          options[:only] = fields if fields.present?

          self._protobuf_field_options = options
        end

        def protobuf_message(message = nil, options = {})
          unless message.nil?
            @protobuf_message = message.to_s.classify.constantize
            self._protobuf_field_options = options
          end

          @protobuf_message
        end

        class CollectionAssociationCaller
          def initialize(method_name)
            @method_name = method_name
          end

          def call(selph)
            selph.__send__(@method_name).to_a
          rescue NameError
            nil
          end
        end

        def _protobuf_collection_association_object(field)
          CollectionAssociationCaller.new(field)
        end

        class DateCaller
          def initialize(field)
            @field = field
          end

          def call(selph)
            value = selph.__send__(@field)

            value&.to_time&.utc&.to_i
          rescue NameError
            nil
          end
        end

        class DateTimeCaller
          def initialize(field)
            @field = field
          end

          def call(selph)
            value = selph.__send__(@field)

            value&.to_i
          rescue NameError
            nil
          end
        end

        class NoConversionCaller
          def initialize(field)
            @field = field
          end

          def call(selph)
            selph.__send__(@field)
          rescue NameError
            nil
          end
        end

        def _protobuf_convert_to_fields_object(field)
          is_datetime_time_or_timestamp_field = _protobuf_date_datetime_time_or_timestamp_field?(field)
          is_date_field = _protobuf_date_field?(field)

          if is_datetime_time_or_timestamp_field
            if is_date_field
              DateCaller.new(field)
            else
              DateTimeCaller.new(field)
            end
          else
            NoConversionCaller.new(field)
          end
        end

        def _protobuf_field_transformer_object(field)
          _protobuf_field_transformers[field]
        end

        class NilMethodCaller
          def initialize; end

          def call(_selph)
            nil
          end
        end

        def _protobuf_nil_object(_field)
          NilMethodCaller.new
        end

        class FieldSymbolTransformerCaller
          def initialize(instance_class, method_name)
            @instance_class = instance_class
            @method_name = method_name
          end

          def call(selph)
            @instance_class.__send__(@method_name, selph)
          end
        end

        def _protobuf_symbol_transformer_object(field)
          FieldSymbolTransformerCaller.new(self, _protobuf_field_symbol_transformers[field])
        end
      end

      def _filter_field_attributes(options = {})
        options = _normalize_options(options)

        fields = _filtered_fields(options)
        fields &= [options[:only]].flatten if options[:only].present?
        fields -= [options[:except]].flatten if options[:except].present?

        fields
      end

      def _filtered_fields(options = {})
        include_deprecated = options.fetch(:deprecated, true)

        fields = []
        fields.concat(self.class._protobuf_message_non_deprecated_fields)
        fields.concat(self.class._protobuf_message_deprecated_fields) if include_deprecated
        fields.concat([options[:include]].flatten) if options[:include].present?
        fields.compact!
        fields.uniq!

        fields
      end

      def _is_collection_association?(field)
        reflection = self.class.relations[field.to_s]
        return false unless reflection

        reflection.class.name.split('::').last.to_sym == :has_many
      end

      def _normalize_options(options)
        options ||= {}
        options[:only] ||= [] if options.fetch(:except, false)
        options[:except] ||= [] if options.fetch(:only, false)

        self.class._protobuf_field_options.merge(options)
      end

      def fields_from_document(options = {})
        hash = {}
        field_attributes = _filter_field_attributes(options)

        if options[:include].present?
          field_attributes.concat([options[:include]].flatten)
          field_attributes.compact!
          field_attributes.uniq!
        end

        field_attributes.each do |field|
          field_object = _protobuf_field_objects(field)
          hash[field] = field_object.call(self)
        end

        hash
      end

      # TODO: Assignment Branch Condition size for _protobuf_field_objects is too high. [<1, 19, 7> 20.27/17]
      def _protobuf_field_objects(field)
        self.class._protobuf_field_objects[field] ||=
          if _protobuf_field_symbol_transformers.key?(field)
            self.class._protobuf_symbol_transformer_object(field)
          elsif _protobuf_field_transformers.key?(field)
            self.class._protobuf_field_transformer_object(field)
          elsif respond_to?(field)
            if _is_collection_association?(field)
              self.class._protobuf_collection_association_object(field)
            else
              self.class._protobuf_convert_to_fields_object(field)
            end
          else
            self.class._protobuf_nil_object(field)
          end
      end

      def _protobuf_field_symbol_transformers
        self.class._protobuf_field_symbol_transformers
      end

      def _protobuf_field_transformers
        self.class._protobuf_field_transformers
      end

      def _protobuf_message
        self.class.protobuf_message
      end

      def to_proto(options = {})
        raise MessageNotDefined, self.class if _protobuf_message.nil?

        fields = fields_from_document(options)
        _protobuf_message.new(fields)
      end
    end
  end
end
