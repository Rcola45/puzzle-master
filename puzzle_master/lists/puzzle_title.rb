class PuzzleTitle
  attr_accessor :title

  PUZZLE_TITLES = [
    "Your 'doku, m'Puzzler",
    "In all it's glory",
    'and God said "Let there be puzzles"',
    'U R L'
  ].freeze

  def initialize
    @title = PUZZLE_TITLES.sample
  end
end
