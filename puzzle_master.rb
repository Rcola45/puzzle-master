require 'slack-ruby-bot'
require './puzzle_master/sudoku'
require './puzzle_master/lists/puzzle_title'

class PuzzleMaster < SlackRubyBot::Bot
  # Matching `sudoku` or `sudoku <difficulty>`
  match(/^!sudoku( (?<difficulty>\w+))?/i) do |client, data, match|
    difficulty = %w[medium hard].sample if match[:difficulty].nil? || match[:difficulty] == 'morning'
    difficulty ||= match[:difficulty]

    sudoku = Sudoku.new(difficulty, slack_data: data, morning: (match[:difficulty] == 'morning'))

    message = sudoku.slack_response
    puts "Responding to '!sudoku' command with:\n#{message}"
    respond_to_slack(client, data, message)
  end

  class << self
    def respond_to_slack(client, data, message)
      # Send message back to slack
      options = { channel: data.channel, text: message }
      options.merge!({ thread_ts: data.thread_ts }) if data.thread_ts
      client.say(options)
    end
  end
end
