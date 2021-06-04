require_relative '../lib/war_player'

describe 'WarPlayer' do
    it 'recieves and stores a hand of cards upon initialization (also tests play_card method)' do 
        player = WarPlayer.new('hobart',[PlayingCard.new('2','spades'),PlayingCard.new('10','hearts'),PlayingCard.new('A','clubs')])
        expect(player.play_card.rank).to(eq('A'))
        expect(player.play_card.suit).to(eq('hearts'))
    end
    it 'takes won cards and puts them on the bottom of the hand' do 
        player = WarPlayer.new('cliff',[])
        expect(player.cards_left).to(eq(0))
        player.take_cards([PlayingCard.new('2','spades'),PlayingCard.new('10','hearts')])
        expect(player.cards_left).to(eq(2))
        card = player.play_card
        expect(card.rank == '10' || card.rank == '2').to(eq(true))
    end
end
