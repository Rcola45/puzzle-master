require 'slack-ruby-bot'
require './puzzle_master/sudoku'
require './puzzle_master/lists/puzzle_title'

class PuzzleMaster < SlackRubyBot::Bot
  # Matching `sudoku` or `sudoku <difficulty>`
  match(/^!sudoku( (?<difficulty>\w+))?/i) do |client, data, match|
    if match[:difficulty] == 'morning'
      response = 'Good Morning, Puzzlers'
      difficulty = %w[medium hard].sample
    end
    difficulty = %w[medium hard].sample if match[:difficulty].nil?
    difficulty ||= match[:difficulty]

    sudoku = Sudoku.new(difficulty, slack_data: data)
    response ||= sudoku.response

    message = build_message(response, sudoku.url, difficulty)
    puts "Responding to '!sudoku' command with: #{message}"
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
