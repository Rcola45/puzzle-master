require 'open-uri'

class Sudoku
  attr_reader :difficulty, :numerical_difficulty, :url

  BASE_URL = 'https://sudokuexchange.com/play/'.freeze
  FETCH_BASE_URL = 'https://raw.githubusercontent.com/grantm/sudoku-exchange-puzzle-bank/master/'.freeze
  DIFFICULTIES = %w[easy medium hard diabolical].freeze
  RESPONSES = [
    'Of course, Puzzlers',
    'As you wish, Puzzlers',
    'I wouldn\'t have it any other way, Puzzlers',
    'This one should tickle your fancy, Puzzlers',
    'I am at your beck and call, Puzzlers',
    'Here\'s one for the ages, Puzzlers',
    'This one is :chefs-kiss:, Puzzlers',
    'I solved this in 1:27. Try and catch up, Puzzlers',
    '{{user}} has requested a puzzle for their fellow Puzzlers',
    'X-Wing on this one would only slow you down, Puzzlers',
    'I go to bed...and all I see in my head...is grids...Puzzlers',
    "{{user}} has requested someone get me out of this computer!\nJust kidding, its another sudoku, Puzzlers",
    'Put a 3 in row seven, column four, trust me Puzzlers'
  ].freeze

  def initialize(difficulty = nil, slack_data: nil, morning: false)
    @difficulty = ([difficulty&.downcase] & DIFFICULTIES).first || 'medium'
    @numerical_difficulty = '0'
    @url = nil
    @sudoku = nil
    @fetch_url = "#{FETCH_BASE_URL}#{@difficulty}.txt"
    @slack_data = slack_data
    @is_morning = morning

    build_puzzle_url
  end

  def refresh
    # Refreshes list of puzzle urls
    build_puzzle_url
  end

  def response(index = nil)
    # Specific response or random
    resp = (index ? RESPONSES[index] : RESPONSES.sample)
    sub_tags(resp)
  end

  def slack_response
    @url ||= 'I couldn\'t do it. I couldn\t find a sudoku for all you fine Puzzlers today :pepehands:'
    message = @is_morning ? 'Good Morning, Puzzlers' : response
    message << "\n<#{@url}|#{PuzzleTitle.new.title}>"
    message << "\nDifficulty Level: #{@difficulty.capitalize}" if @difficulty
    message << " (#{@numerical_difficulty})" if @numerical_difficulty
    message
  end

  def to_s
    @sudoku
  end

  private

  # Returns array of urls to puzzles
  def build_puzzle_url
    fetch_sudoku
    @url = "#{BASE_URL}?s=#{@sudoku}"
  end

  def fetch_sudoku
    return unless @fetch_url.end_with? '.txt'

    file = open(@fetch_url)
    lines = file.readlines
    line = lines[rand(lines.size)].split(' ')
    @sudoku = line[1]
    @numerical_difficulty = line[2]
    file.close
  end

  def difficulty_index
    # medium (1) by default
    case @difficulty
    when 'easy'
      1
    when 'hard'
      3
    when 'diabolical'
      4
    else
      2
    end
  end

  def sub_tags(resp)
    return resp unless @slack_data

    resp.gsub!('{{user}}', "<@#{@slack_data.user}>")
    resp
  end
end
