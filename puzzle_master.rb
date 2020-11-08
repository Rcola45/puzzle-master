require 'slack-ruby-bot'
require './puzzle_master/sudoku'

class PuzzleMaster < SlackRubyBot::Bot
  # Matching `sudoku` or `sudoku <difficulty>`
  match(/^sudoku( (?<difficulty>\w+))?/i) do |client, data, match|
    sudoku = new_sudoku(match[:difficulty])
    message = build_message(sudoku.response, sudoku.url, sudoku.difficulty)
    respond_to_slack(client, data, message)
  end

  match(/morning/i) do |client, data, _match|
    sudoku = new_sudoku
    message = build_message('Good Morning, Puzzlers', sudoku.url, sudoku.difficulty)
    respond_to_slack(client, data, message)
  end

  class << self
    def build_message(response, url, difficulty = nil)
      url ||= 'I couldn\'t do it. I couldn\t find a sudoku for all you fine Puzzlers today :pepehands:'
      message = "#{response}\n#{url}"
      message << "\nDifficulty Level: #{difficulty.capitalize}" if difficulty
      message
    end

    def new_sudoku(difficulty = nil)
      Sudoku.new(difficulty)
    end

    def respond_to_slack(client, data, message)
      # Send message back to slack
      client.say(channel: data.channel, text: message)
    end
  end
end
