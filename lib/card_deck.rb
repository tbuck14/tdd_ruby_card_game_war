
class CardDeck

  def initialize
    @cards_left = 52
    @deck = [PlayingCard.new('2','spades'),PlayingCard.new('3','spades'),PlayingCard.new('4','spades'),PlayingCard.new('5','spades'),
    PlayingCard.new('6','spades'),PlayingCard.new('7','spades'),PlayingCard.new('8','spades'),PlayingCard.new('9','spades'),
    PlayingCard.new('10','spades'),PlayingCard.new('J','spades'),PlayingCard.new('Q','spades'),PlayingCard.new('K','spades'),
    PlayingCard.new('A','spades'),PlayingCard.new('2','hearts'),PlayingCard.new('3','hearts'),PlayingCard.new('4','hearts'),PlayingCard.new('5','hearts'),
    PlayingCard.new('6','hearts'),PlayingCard.new('7','hearts'),PlayingCard.new('8','hearts'),PlayingCard.new('9','hearts'),
    PlayingCard.new('10','hearts'),PlayingCard.new('J','hearts'),PlayingCard.new('Q','hearts'),PlayingCard.new('K','hearts'),
    PlayingCard.new('A','hearts'),PlayingCard.new('2','clubs'),PlayingCard.new('3','clubs'),PlayingCard.new('4','clubs'),PlayingCard.new('5','clubs'),
    PlayingCard.new('6','clubs'),PlayingCard.new('7','clubs'),PlayingCard.new('8','clubs'),PlayingCard.new('9','clubs'),
    PlayingCard.new('10','clubs'),PlayingCard.new('J','clubs'),PlayingCard.new('Q','clubs'),PlayingCard.new('K','clubs'),
    PlayingCard.new('A','clubs'),PlayingCard.new('2','diamonds'),PlayingCard.new('3','diamonds'),PlayingCard.new('4','diamonds'),PlayingCard.new('5','diamonds'),
    PlayingCard.new('6','diamonds'),PlayingCard.new('7','diamonds'),PlayingCard.new('8','diamonds'),PlayingCard.new('9','diamonds'),
    PlayingCard.new('10','diamonds'),PlayingCard.new('J','diamonds'),PlayingCard.new('Q','diamonds'),PlayingCard.new('K','diamonds'),
    PlayingCard.new('A','diamonds')]
  end
  
  def cards_left
    @cards_left
  end

  def deal
    @cards_left -=1
    @deck.pop()
  end

  def shuffle 
    @deck.shuffle!
  end

end
