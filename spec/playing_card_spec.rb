require_relative '../lib/playing_card'

describe 'PlayingCard' do
    describe '#suit' do
        it('returns the suit of the card') do 
            card = PlayingCard.new('2','spades')
            expect(card.suit).to(eq('spades'))
        end
    end
    describe '#rank' do
        it('returns the rank and suit of the card') do 
            card = PlayingCard.new('2','spades')
            expect(card.rank).to(eq('2'))
            expect(card.suit).to(eq('spades'))
        end
    end
    it ('has a valid rank and suit') do
        card = PlayingCard.new('2','spades')
        valid_ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
        valid_suits = ['hearts', 'spades','clubs','diamonds']
        expect(valid_ranks).to include card.rank
        expect(valid_suits).to include card.suit
    end
    it ('returns a value for the card') do
        card = PlayingCard.new('2','spades')
        expect(card.value).to(eq(2))
        card = PlayingCard.new('K','spades')
        expect(card.value).to(eq(13))
    end
end