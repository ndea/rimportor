require 'parallel'

module Rimportor
  module ActiveRecord
    class Import

      def initialize(bulk)
        @bulk = bulk
      end

      def import_statement
        insert_statement = SqlBuilder.new(@bulk.first).full_insert_statement
        result = ::Parallel.map(@bulk.drop(1), in_threads: 4) do |element|
          SqlBuilder.new(element).partial_insert_statement.gsub('VALUES', '')
        end
        "#{insert_statement},#{result.join(',')}"
      end

      def exec_statement
        ::ActiveRecord::Base.connection.execute import_statement
      end

    end
  end
end