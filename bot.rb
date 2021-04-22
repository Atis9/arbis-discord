module Arbis
  class Bot
    def initialize(token)
      raise ArgumentError if !token.is_a?(String) || token.size.zero?

      @token = token
      require_relative 'config/initializer.rb'
      Arbis::Initializer.load_requirement
      Arbis::Initializer.load_lib
      Arbis::Initializer.load_config
      Arbis::Initializer.load_handler
      Arbis::Initializer.load_action
    end

    def run
      client = Discordrb::Bot.new(token: @token)
      Arbis::Handler.activate(client)
      client.run
    end
  end
end
