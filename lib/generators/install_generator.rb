require 'rails/generators'

module Rimportor
  class InstallGenerator < ::Rails::Generators::Base
    source_root(File.expand_path(File.dirname(__FILE__)))

    def copy_initializer
      copy_file '../templates/rimportor.rb', 'config/initializers/rimportor.rb'
    end
  end
end