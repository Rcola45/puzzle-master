$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require './puzzle_master'
puts "TOKEN: #{ENV['SLACK_API_TOKEN']}"
PuzzleMaster.run
