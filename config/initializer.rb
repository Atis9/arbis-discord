module Arbis
  class Initializer
    def self.load_requirement
      require 'yaml'
      require 'pathname'
      require 'logger'
      require 'active_support/all'
      require 'discordrb'
    end

    def self.load_lib
      Dir[File.expand_path('../../lib', __FILE__) << '/*.rb'].each do |filepath|
        require_relative filepath
      end
    end

    def self.load_config
      require_relative 'config.rb'

      Dir[File.expand_path('../../config', __FILE__) << '/*.yml'].each do |filepath|
        Arbis::Config.load_and_define(filepath)
      end
    end

    def self.load_handler
      Dir[File.expand_path('../../handler', __FILE__) << '/*.rb'].each do |filepath|
        require_relative filepath
      end
    end

    def self.load_action
      Dir[File.expand_path('../../action', __FILE__) << '/*.rb'].each do |filepath|
        require_relative filepath
      end
    end
  end
end
