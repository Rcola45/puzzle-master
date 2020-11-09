require 'slack-ruby-bot'
require './puzzle_master/sudoku'
require './puzzle_master/lists/puzzle_title'

class PuzzleMaster < SlackRubyBot::Bot
  # Matching `sudoku` or `sudoku <difficulty>`
  match(/^!pm sudoku( (?<difficulty>\w+))?/i) do |client, data, match|
    sudoku = Sudoku.new(match[:difficulty], slack_data: data)
    message = build_message(sudoku.response, sudoku.url, sudoku.difficulty)
    puts "Responding to 'sudoku' command with: #{message}"
    respond_to_slack(client, data, message)
  end

  match(/^!pm morning/i) do |client, data, _match|
    sudoku = Sudoku.new(slack_data: data)
    message = build_message('Good Morning, Puzzlers', sudoku.url, sudoku.difficulty)
    puts "Responding to 'morning' command with: #{message}"
    respond_to_slack(client, data, message)
  end

  class << self
    def build_message(response, url, difficulty = nil)
      url ||= 'I couldn\'t do it. I couldn\t find a sudoku for all you fine Puzzlers today :pepehands:'
      message = response
      message << "\n<#{url}|#{PuzzleTitle.new.title}>"
      message << "\nDifficulty Level: #{difficulty.capitalize}" if difficulty
      message
    end

    def respond_to_slack(client, data, message)
      # Send message back to slack
      options = { channel: data.channel, text: message }
      options.merge!({ thread_ts: data.thread_ts }) if data.thread_ts
      client.say(options)
    end
  end
end
