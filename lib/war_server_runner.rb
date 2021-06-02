require 'socket'
require_relative 'war_socket_server'
require_relative 'war_game'
require_relative 'war_player'
require_relative 'card_deck'
require_relative 'playing_card'
require_relative 'war_runner_new'
server = WarSocketServer.new
server.start
until server.clients.count == 2 do 
    server.accept_new_client("player #{server.clients.count+1}")
end
game = server.create_game_if_possible
server.clients[0]['client'].puts('you are player 1')
server.clients[1]['client'].puts('you are player 2')
until game.winner do
    loop do
        server.clients[0]['client'].puts('play round?')
        answer = ''
        loop do
            server.capture_output
            answer = server.output.downcase
            break if answer != ""
        end
        break if answer == 'yes'
    end
    loop do
        server.clients[1]['client'].puts('play round?')
        answer = ''
        loop do
            server.capture_output
            answer = server.output.downcase
            break if answer != ""
        end
        break if answer == 'yes'
    end
    result = game.play_round
    server.clients[1]['client'].puts(result)
    server.clients[0]['client'].puts(result)
end
server.clients[0]['client'].puts("Winner: #{game.winner.name}")
server.clients[1]['client'].puts("Winner: #{game.winner.name}")
server.clients[0]['client'].puts('break')
server.clients[1]['client'].puts('break')