module Rimportor
  module ActiveRecord
    module Adapter
      class Mysql2

        def max_allowed_packet
          ::ActiveRecord::Base.connection_pool.with_connection do |connection|
            result = connection.execute("SHOW VARIABLES like 'max_allowed_packet';")
            val = result.respond_to?(:fetch_row) ? result.fetch_row[1] : result.first[1]
            val.to_i
          end
        end

      end
    end
  end
end