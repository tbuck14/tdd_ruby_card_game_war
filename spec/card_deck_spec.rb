require_relative '../lib/card_deck'

describe 'CardDeck' do
  it 'Should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 52
  end

  it 'should deal the top card' do
    deck = CardDeck.new
    card = deck.deal
    expect(card.rank).to(eq('A'))
    expect(card.suit).to(eq('diamonds'))
    expect(deck.cards_left).to(eq(51))
  end
  
  it 'shoud shuffle the deck' do 
    deck = CardDeck.new
    deck.shuffle
    card1_suit = deck.deal.suit
    card2_suit = deck.deal.suit
    card3_suit = deck.deal.suit
    card4_suit = deck.deal.suit
    card5_suit = deck.deal.suit
    expect([card1_suit,card2_suit,card3_suit,card4_suit,card5_suit]).to_not(eq(['diamonds','diamonds','diamonds','diamonds','diamonds']))
  end
end
