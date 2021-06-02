 class WarGame
    attr_reader :player_one, :player_two
    def initialize(playerOne = WarPlayer.new('player one'), playerTwo = WarPlayer.new('player two'))
        @player_one = playerOne 
        @player_two = playerTwo 
    end

    def start()
        deck = CardDeck.new()
        deck.shuffle
        while deck.cards_left != 0 
            @player_one.take_cards([deck.deal])
            @player_two.take_cards([deck.deal])
        end
    end

    def winner()
        if @player_one.cards_left == 0 
            return @player_two
        elsif @player_two.cards_left == 0 
            return @player_one
        else
           return false
        end
    end

    def play_round(r_cards = [])
        round_cards = r_cards
        p1_card = @player_one.play_card
        p2_card = @player_two.play_card
        round_cards.push(p1_card, p2_card)
        if p1_card.value > p2_card.value 
            puts "#{@player_one.name} took #{p2_card.rank} of #{p2_card.suit} with #{p1_card.rank} of #{p1_card.suit} plus any additional war cards"
            @player_one.take_cards(round_cards)
        elsif p2_card.value > p1_card.value
            puts "#{@player_two.name} took #{p1_card.rank} of #{p1_card.suit} with #{p2_card.rank} of #{p2_card.suit} plus any additional war cards"
            @player_two.take_cards(round_cards)
        else
            puts "tie! between #{@player_one.name}'s #{p1_card.rank} and #{@player_two.name}'s #{p2_card.rank}"
            play_round(round_cards)
        end
    end

 end