 class WarGame
    attr_reader :player_one, :player_two, :round_info
    def initialize(playerOne = WarPlayer.new('player one'), playerTwo = WarPlayer.new('player two'))
        @player_one = playerOne 
        @player_two = playerTwo
        @round_info = ""
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

    def play_round(r_cards = [], card1 = @player_one.play_card, card2 = @player_two.play_card)
        r_cards.push(card1, card2)
        war_result = get_war_cards(@player_one, @player_two) if card2.value == card1.value
        r_cards += war_result if card2.value == card1.value
        round_result(card1, card2, r_cards, @player_one) if card1.value > card2.value
        round_result(card2, card1, r_cards, @player_two) if card2.value > card1.value
        play_round(r_cards) if (war_result != nil && war_result.count == 6) && @player_one.cards_left > 0 && @player_two.cards_left > 0
    end
    
    def get_war_cards(player_one, player_two)
        war_cards = []
        3.times do 
            war_cards.push(player_one.play_card) if player_one.cards_left > 0 
            war_cards.push(player_two.play_card) if player_two.cards_left > 0
        end
        return war_cards
    end

    def round_result(winning_card, losing_card, total_cards_won, winning_player)
        winning_player.take_cards(total_cards_won)
        @round_info = "#{winning_player.name} has taken #{losing_card.rank} of #{losing_card.suit} with a #{winning_card.rank} of #{winning_card.suit}, total cards taken: #{total_cards_won.count}"
        puts @round_info
    end
 end