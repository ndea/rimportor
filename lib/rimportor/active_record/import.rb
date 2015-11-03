require 'parallel'

module Rimportor
  module ActiveRecord
    class Import

      def initialize(bulk, adapter, opts = {})
        @bulk = bulk
        @adapter = adapter
        @before_callbacks = !!opts[:before_callbacks]
        @after_callbacks = !!opts[:after_callbacks]
        @validate_bulk = !!opts[:validate_bulk]
        @batch_size = opts[:batch_size] ? opts[:batch_size] : 1000
        @threads = Rimportor.configuration.threads
      end

      def run_before_callbacks
        ::Parallel.map(@bulk, in_threads: @threads) do |element|
          execute_callbacks(element, :before)
        end
      end

      def run_after_callbacks
        ::Parallel.map(@bulk, in_threads: @threads) do |element|
          execute_callbacks(element, :after)
        end
      end

      def run_validations
        validation_result = ::Parallel.map(@bulk, in_threads: @threads) do |element|
          element.valid?
        end.all?
        raise Rimportor::Error::BulkValidation.new("Your bulk is not valid") unless validation_result
      end

      def execute_callbacks(element, before_or_after)
        case before_or_after
          when :before
            element.run_callbacks(:save) { false }
          when :after
            element.run_callbacks(:save) { true }
        end
      end

      def import_statement(batch)
        insert_statement = SqlBuilder.new(batch.first).full_insert_statement
        result = ::Parallel.map(batch.drop(1), in_threads: @threads) do |element|
          @adapter.exec_in_pool { SqlBuilder.new(element).partial_insert_statement.gsub('VALUES', '') }
        end
        [insert_statement, result]
      end

      def exec_statement
        begin
          run_validations if @validate_bulk
          run_before_callbacks if @before_callbacks
          @bulk.each_slice(@batch_size) do |batch|
            @adapter.exec_insert(import_statement(batch))
          end
          run_after_callbacks if @after_callbacks
          true
        rescue => e
          puts "Error importing the bulk. Reason #{e.message}"
          false
        end
      end

    end
  end
end