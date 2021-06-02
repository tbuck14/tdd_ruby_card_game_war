 class WarPlayer
        attr_reader :cards_left, :name
    def initialize(name, hand=[])
        @hand = hand
        @cards_left = @hand.count
        @name = name
    end

    def take_cards(cards) 
       cards.shuffle!
       @hand.unshift(cards).flatten!
       @cards_left += cards.count
    end

    def play_card()
        @cards_left -= 1
        @hand.pop()
    end

 end
