$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'slack-ruby-bot'
SlackRubyBot::Client.logger.level = Logger::WARN

require './puzzle_master'

PuzzleMaster.run
