#! /usr/bin/env ruby

require_relative 'bot.rb'
bot = Arbis::Bot.new(ENV["DISCORD_BOT_TOKEN"])
bot.run
