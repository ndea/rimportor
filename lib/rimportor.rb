require 'rimportor/active_record/sql_builder'
require 'rimportor/active_record/import'
require 'rimportor/plugin'
require 'rimportor/error/bulk_validation'

module Rimportor
end

ActiveRecord::Base.send :include, Rimportor::Plugin