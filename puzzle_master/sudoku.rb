require_relative './puzzle_driver'

class Sudoku
  attr_reader :difficulty, :puzzles

  BASE_URL = 'https://sudokuexchange.com/play/'.freeze
  RESPONSES = [
    'Of course, Puzzlers',
    'As you wish, Puzzlers',
    'I wouldn\'t have it any other way, Puzzlers',
    'This one should tickle your fancy, Puzzlers',
    'I am at your beck and call, Puzzlers',
    'Here\'s one for the ages, Puzzlers',
    'This one is :chefs-kiss:, Puzzlers',
    'I solved this in 1:27. Try and catch up, Puzzlers',
  ].freeze

  def initialize(difficulty = nil)
    @difficulty = difficulty&.downcase || 'medium'
    @puzzle_urls = []
    fetch_puzzles
  end

  def url(index = nil)
    # Specific puzzle or random
    index ? @puzzle_urls[index] : @puzzle_urls.sample
  end

  def urls
    @puzzle_urls
  end

  def refresh
    # Refreshes list of puzzle urls
    @puzzle_urls = fetch_puzzles
  end

  def response(index = nil)
    # Specific response or random
    index ? RESPONSES[index] : RESPONSES.sample
  end

  private

  # Returns array of urls to puzzles
  def fetch_puzzles
    css = ".recently-shared .section:nth-child(#{difficulty_index}) ul a"

    puzzle_driver = PuzzleDriver.new
    puzzle_driver.get(BASE_URL)
    @puzzle_urls = puzzle_driver.find_elements_from_css(css).map { |link| link['href'] }
    puzzle_driver.quit
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
end
