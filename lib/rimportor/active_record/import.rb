require 'parallel'

module Rimportor
  module ActiveRecord
    class Import

      def initialize(bulk, opts = {})
        @bulk = bulk
        @before_callbacks = !!opts[:before_callbacks]
        @after_callbacks = !!opts[:after_callbacks]
        @validate_bulk = !!opts[:validate_bulk]
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

      def import_statement
        insert_statement = SqlBuilder.new(@bulk.first).full_insert_statement
        result = ::Parallel.map(@bulk.drop(1), in_threads: @threads) do |element|
          in_pool { SqlBuilder.new(element).partial_insert_statement.gsub('VALUES', '') }
        end
        "#{insert_statement},#{result.join(',')}"
      end

      def exec_statement
        begin
          run_validations if @validate_bulk
          run_before_callbacks if @before_callbacks
          in_pool { |connection| connection.execute import_statement }
          run_after_callbacks if @after_callbacks
          true
        rescue => e
          puts "Error importing the bulk. Reason #{e.message}"
          false
        end
      end

      def in_pool
        ::ActiveRecord::Base.connection_pool.with_connection do |connection|
          yield(connection)
        end
      end

    end
  end
end