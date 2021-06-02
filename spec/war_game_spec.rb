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
        it 'gives the result of two players playing a card' do 
            game = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('A','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('J','diamonds')]))
            game.play_round
            expect(game.player_one.cards_left).to(eq(2))
            expect(game.player_two.cards_left).to(eq(0))
            game2 = WarGame.new(WarPlayer.new('test playerOne',[PlayingCard.new('2','spades'),PlayingCard.new('A','spades')]),WarPlayer.new('test playerTwo',[PlayingCard.new('4','diamonds'),PlayingCard.new('A','diamonds')]))
            game2.play_round
            expect(game2.player_one.cards_left).to(eq(0))
            expect(game2.player_two.cards_left).to(eq(4))
            expect(game2.winner.name).to(eq(game2.player_two.name))
        end
    end
end
