module Rimportor
  module Plugin
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def rimport(records, options = {})
        ::Rimportor::ActiveRecord::Import.new(records, self.current_adapter, options).exec_statement
      end

      def current_adapter
        load_adapter(::ActiveRecord::Base.connection_config[:adapter])
      end

      def load_adapter(adapter_name)
        begin
          ::Rimportor::ActiveRecord::Adapter.const_get(adapter_name.to_s.camelize).new
        rescue => e
          raise ::Rimportor::Error::InvalidAdapter.new("Invalid adapter. Reason #{e}")
        end
      end

    end

  end
end