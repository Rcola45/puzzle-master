class PuzzleTitle
  attr_accessor :title

  PUZZLE_TITLES = [
    "Your 'doku, m'Puzzler",
    "In all it's glory",
    'and God said "Let there be puzzles"',
    'U R L',
    'www.miniclip.com',
    ':ceo: *Get back to work*!',
    'The final puzzle piece',
    'Click for free prize',
    'Download Now',
    'Every square is a fresh beginning',
    'Reach for the stars',
    's u d o k u',
    'Difficulty: Inferno (16.6)',
    'Difficulty: Dalmations (101)',
    '404 Not Found',
    '¯\_(ツ)_/¯'
  ].freeze

  def initialize
    @title = PUZZLE_TITLES.sample
  end
end
