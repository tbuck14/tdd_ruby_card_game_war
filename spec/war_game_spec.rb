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
        it '' do 

        end
    end

    describe('#play_round') do
        it '' do 
            
        end
    end
end
