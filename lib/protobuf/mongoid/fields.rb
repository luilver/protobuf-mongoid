# frozen_string_literal: true

module Protobuf
  module Mongoid
    # A key-value pair within a document
    module Fields
      include ::Heredity
      extend ::ActiveSupport::Concern

      FIELD_TYPE_MAP_MUTEX = ::Mutex.new
      DATE_OR_TIME_TYPES = ::Set.new(%i[date datetime time timestamp])

      inheritable_attributes :_protobuf_fields,
                             :_protobuf_field_types,
                             :_protobuf_date_datetime_time_or_timestamp_field,
                             :_protobuf_mapped_fields

      ##
      # Class Methods
      #
      module ClassMethods
        def _protobuf_fields
          _protobuf_map_fields unless _protobuf_mapped_fields?

          @_protobuf_fields
        end

        def _protobuf_field_types
          _protobuf_map_fields unless _protobuf_mapped_fields?

          @_protobuf_field_types
        end

        def _protobuf_date_datetime_time_or_timestamp_field
          _protobuf_map_fields unless _protobuf_mapped_fields?

          @_protobuf_date_datetime_time_or_timestamp_field
        end

        # :nodoc:
        def _protobuf_date_field?(key)
          _protobuf_field_types[:date].include?(key)
        end

        # :nodoc:
        def _protobuf_date_datetime_time_or_timestamp_field?(key)
          _protobuf_date_datetime_time_or_timestamp_field.include?(key)
        end

        # :nodoc:
        def _protobuf_datetime_field?(key)
          _protobuf_field_types[:datetime].include?(key)
        end

        # Map out the fields for future reference on type conversion
        # :nodoc:
        # TODO: Check if collection exists
        # collection_exists? is not a Mongoid method. We need to check $exists?
        # return unless collection_exists?
        def _protobuf_map_fields(force = false)
          FIELD_TYPE_MAP_MUTEX.synchronize do
            @_protobuf_mapped_fields = false if force
            return if _protobuf_mapped_fields?

            initialize_protobuf_field_containers
            map_protobuf_fields

            @_protobuf_mapped_fields = true
          end
        end

        def _protobuf_mapped_fields?
          @_protobuf_mapped_fields
        end

        # :nodoc:
        def _protobuf_time_field?(key)
          _protobuf_field_types[:time].include?(key)
        end

        # :nodoc:
        def _protobuf_timestamp_field?(key)
          _protobuf_field_types[:timestamp].include?(key)
        end

        private

        def initialize_protobuf_field_containers
          @_protobuf_fields = {}
          @_protobuf_field_types = ::Hash.new { |h, k| h[k] = ::Set.new }
          @_protobuf_date_datetime_time_or_timestamp_field = ::Set.new
        end

        def map_protobuf_fields
          fields.each do |field|
            field_name_symbol = field[0].to_sym
            field_type_symbol = field[1].options[:type].to_s.to_sym

            @_protobuf_fields[field_name_symbol] = field
            @_protobuf_field_types[field_type_symbol] << field_name_symbol

            if DATE_OR_TIME_TYPES.include?(field_type_symbol)
              @_protobuf_date_datetime_time_or_timestamp_field << field_name_symbol
            end
          end
        end
      end
    end
  end
end
