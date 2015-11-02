module Rimportor
  module ActiveRecord
    class SqlBuilder

      def initialize(model)
        @model = model
        set_timestamps
      end

      def full_insert_statement
        insert_manager.tap do |im|
          im.insert(arel_for_create)
        end.to_sql
      end

      def partial_insert_statement
        insert_manager.insert(arel_for_create).to_sql
      end

      def arel_for_create
        @model.send(:arel_attributes_with_values_for_create, @model.attribute_names)
      end

      def insert_manager
        @model.class.arel_table.create_insert
      end

      def set_timestamps
        set_created_at
        set_updated_at
      end

      def set_created_at
        @model.updated_at = Time.zone.now if @model.respond_to? :updated_at
      end

      def set_updated_at
        @model.created_at = Time.zone.now if @model.respond_to? :created_at
      end

    end
  end
end