module Rimportor
  module Util
    class Connection

      def self.in_pool
        ::ActiveRecord::Base.connection_pool.with_connection do |connection|
          yield(connection)
        end
      end

    end
  end
end