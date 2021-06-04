require_relative '../lib/war_game'

describe 'WarGame' do
    describe('#start') do 
        it 'deals each player half of a deck' do 
            game = WarGame.new()
            game.start()
            expect(game.player_one.cards_left).to(eq(26))
            expect(game.player_two.cards_left).to(eq(26))
        end
    end

    describe('#winner') do 
        it 'returns true if there is a winner' do 
            game = WarGame.new()
            game.start()
            expect(game.winner).to(eq(false))
            26.times do 
                game.player_one.play_card
            end
            expect(game.winner().name).to(eq(game.player_two.name))
        end
    end

    describe('#play_round') do
        it 'player one is the winner when player two lays their last card and it is lower value than player ones card' do 
            game = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('A','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('J','diamonds')]))
            game.play_round
            expect(game.player_one.cards_left).to(eq(2))
            expect(game.player_two.cards_left).to(eq(0))
            expect(game.winner.name).to(eq(game.player_one.name))
        end
        it 'player two is the winner when player one lays their last card and it is lower value than player twos card' do 
            game = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('J','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('Q','diamonds')]))
            game.play_round
            expect(game.player_two.cards_left).to(eq(2))
            expect(game.player_one.cards_left).to(eq(0))
            expect(game.winner.name).to(eq(game.player_two.name))
        end
        it 'creates a war when both players lay the same card' do 
            game2 = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('Q','spades'),PlayingCard.new('J','spades'),PlayingCard.new('K','spades'),PlayingCard.new('2','spades'),PlayingCard.new('A','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('2','diamonds'),PlayingCard.new('5','diamonds'),PlayingCard.new('6','diamonds'),PlayingCard.new('4','diamonds'),PlayingCard.new('A','diamonds')]))
            game2.play_round
            expect(game2.player_two.cards_left).to(eq(0))
            expect(game2.winner.name).to(eq(game2.player_one.name))
        end
         it 'gives a winner when a player runns out of cards during a war' do 
             game2 = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('J','spades'),PlayingCard.new('K','spades'),PlayingCard.new('2','spades'),PlayingCard.new('A','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('2','diamonds'),PlayingCard.new('5','diamonds'),PlayingCard.new('6','diamonds'),PlayingCard.new('4','diamonds'),PlayingCard.new('A','diamonds')]))
             game2.play_round
             expect(game2.player_one.cards_left).to(eq(0))
             expect(game2.winner.name).to(eq(game2.player_two.name))
         end
    end

    describe ("#war") do 
        it 'returns six cards if both players dont run out of cards during a war' do 
            game2 = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('J','spades'),PlayingCard.new('K','spades'),PlayingCard.new('2','spades'),PlayingCard.new('A','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('2','diamonds'),PlayingCard.new('5','diamonds'),PlayingCard.new('6','diamonds'),PlayingCard.new('4','diamonds'),PlayingCard.new('A','diamonds')]))
            expect(game2.get_war_cards(game2.player_one, game2.player_two).count).to(eq(6))
        end
        it 'returns less than six cards if one player runs out during a war' do 
            game2 = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('J','spades'),PlayingCard.new('K','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('2','diamonds'),PlayingCard.new('5','diamonds'),PlayingCard.new('6','diamonds'),PlayingCard.new('4','diamonds'),PlayingCard.new('A','diamonds')]))
            expect(game2.get_war_cards(game2.player_one, game2.player_two).count).to(eq(5))
        end
    end
   
end
