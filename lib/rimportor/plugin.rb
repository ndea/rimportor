module Rimportor
  module Plugin
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def rimport(records, options = {})
        if options[:run_callbacks]
          records = ::Rimportor::ActiveRecord::Import.new
        end
        ::Rimportor::ActiveRecord::Import.new(records).exec_statement
      end
    end

  end
end