require 'socket'
require_relative 'war_game'
require_relative 'war_player'
require_relative 'card_deck'
require_relative 'playing_card'
require_relative 'player'



class WarSocketServer
    attr_reader :games, :players, :output
    attr_accessor :new_player_count
  def initialize
    @games = []
    @players = []
    @new_player_count = 0 
  end

  def port_number
    3336
  end

  def welcome_message
    @players.each do |player|
        player.client.puts('welcome')
    end
  end

  def start
    puts "Server Started!"
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    player = Player.new(WarPlayer.new(player_name),client,false)
    @players.push(player)
    @new_player_count += 1
    puts "Client #{player_name} Connected!"
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    #puts "No client to accept"
  end

  def create_game_if_possible
    if @players.length == 2
       game = WarGame.new(@players[0].war_player, @players[1].war_player)
       @games.push(game)
       @new_player_count = 0 
       return game
    else
       return false
    end
  end

  def can_play_round? 
    if @players[0].ready && @players[1].ready
        return true
    else
        return false
    end
  end

  def capture_output(client_number)
     sleep(0.1)
     @output = @players[client_number].client.read_nonblock(1000).chomp 
     rescue IO::WaitReadable
     @output = ""
  end

  def stop
    @server.close if @server
  end
end












#SERVER RUNNER SCRIPT

def game_script(server,game,game_count) 
    game.start
    server.players[game_count-2].client.puts('welcome to the game of war! You are player 1')
    server.players[game_count-1].client.puts('welcome to the game of war! You are player 2')
    until game.winner do
        server.players[game_count-2].client.puts('ready?')
        output = ""
        until output != ""
            output = server.capture_output(game_count-2)
        end
        server.players[game_count-1].client.puts('ready?')
        output = ""
        until output != ""
            output = server.capture_output(game_count-1)
        end
        game.play_round
        result = game.round_info
        server.players[game_count-2].client.puts(result)
        server.players[game_count-1].client.puts(result)
    end 
end
war_server = WarSocketServer.new()
war_server.start
war_game_count = 0 
while true
    until war_server.new_player_count == 2 do 
        war_server.accept_new_client("player #{war_server.players.count + 1}")
    end
    war_game_count+=2
    war_game = war_server.create_game_if_possible
    #Thread.new(war_server, war_game, war_game_count){|war_server, war_game, war_game_count|game_script(war_server,war_game,war_game_count)}
    game_script(war_server,war_game,war_game_count)
end
war_server.players.each do |player|
    player.client.close
end
war_server.stop