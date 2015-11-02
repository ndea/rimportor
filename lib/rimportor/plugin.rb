module Rimportor
  module Plugin
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def rimport(records, options = {})
        ::Rimportor::ActiveRecord::Import.new(records, options).exec_statement
      end

      def rimport!(records, options = {})

      end

    end

  end
end