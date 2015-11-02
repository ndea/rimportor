module Rimportor
  module Plugin
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def rimport(records, options = {})
        ::Rimportor::ActiveRecord::Import.new(records).exec_statement
      end
    end

  end
end