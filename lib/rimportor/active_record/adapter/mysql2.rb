module Rimportor
  module ActiveRecord
    module Adapter
      class Mysql2

        # Returns maximum number of bytes that the server will accept for a query
        # @return [Fixnum] number of maximum allowed packet size
        def max_allowed_packet
          exec_in_pool do |connection|
            result = connection.execute("SHOW VARIABLES like 'max_allowed_packet';")
            val = result.respond_to?(:fetch_row) ? result.fetch_row[1] : result.first[1]
            val.to_i
          end
        end

        def exec_in_pool
          ::Rimportor::Util::Connection.in_pool do |connection|
            yield(connection)
          end
        end

        # Checks if the given statement is too big for the database insert
        # @return [TrueClass, FalseClass] true if the statement size is too big for the database else false
        def statement_too_big?(statement)
          statement.size > max_allowed_packet
        end

        def exec_insert(import_statement)
          insert_statement, value_statements = import_statement
          if statement_too_big? ("#{insert_statement}, #{value_statements.join(',')}")
            puts 'Statement too big'
          else
            exec_statement "#{insert_statement},#{value_statements.join(',')}"
          end
        end

        def exec_statement(statement)
          exec_in_pool { |connection| connection.execute statement }
        end

      end
    end
  end
end