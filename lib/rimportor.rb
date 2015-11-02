require 'rimportor/active_record/sql_builder'
require 'rimportor/active_record/import'
require 'rimportor/plugin'
require 'rimportor/error/bulk_validation'
require 'generators/install_generator'

module Rimportor
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :threads

    def initialize
      @threads = 4
    end
  end
end

ActiveRecord::Base.send :include, Rimportor::Plugin