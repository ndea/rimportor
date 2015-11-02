require 'parallel'

module Rimportor
  module ActiveRecord
    class Import

      def initialize(bulk, opts = {})
        @bulk = bulk
        @before_callbacks = !!opts[:exec_before_callbacks]
        @after_callbacks = !!opts[:exec_after_callbacks]
      end

      def run_before_callbacks
        ::Parallel.map(@bulk, in_threads: 4) do |element|
          element.execute_callbacks(element, :before)
        end
      end

      def run_after_callbacks
        ::Parallel.map(@bulk, in_threads: 4) do |element|
          element.execute_callbacks(element, :after)
        end
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
        result = ::Parallel.map(@bulk.drop(1), in_threads: 4) do |element|
          SqlBuilder.new(element).partial_insert_statement.gsub('VALUES', '')
        end
        "#{insert_statement},#{result.join(',')}"
      end

      def exec_statement
        run_before_callbacks if @before_callbacks
        ::ActiveRecord::Base.connection.execute import_statement
        run_after_callbacks if @after_callbacks
      end

    end
  end
end