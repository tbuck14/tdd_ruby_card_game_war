require_relative 'war_game'
require_relative 'war_player'
require_relative 'card_deck'
require_relative 'playing_card'
game = WarGame.new
game.start
until game.winner do
  puts game.play_round
end
puts "Winner: #{game.winner.name}"
