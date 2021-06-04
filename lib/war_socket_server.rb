require 'socket'
require_relative 'war_game'
require_relative 'war_player'
require_relative 'card_deck'
require_relative 'playing_card'
require_relative 'player'



class WarSocketServer
    attr_reader :games, :players, :output, :game_with_players
  def initialize
    @games = []
    @players = [] 
    @game_with_players = {}
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
    puts "Client #{player_name} Connected!"
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    #puts "No client to accept"
  end

  def create_game_if_possible
    if @players.length == 2
       game = WarGame.new(@players[0].war_player, @players[1].war_player)
       @games.push(game)
       @game_with_players[game] = {'player1'=>@players[0], 'player2'=>@players[1]}
       @players = []
       return game
    end
  end

  def can_play_round?(game)
    send_player_message_expect_response(game,'player1','play round?')
    puts "made it here"
    send_player_message_expect_response(game,'player2','play round?')
  end

  #pass in the game and either 'player1' or 'player2'
  def capture_output(game,player)
     sleep(0.1)
     @output = @game_with_players[game][player].client.read_nonblock(1000).chomp 
     rescue IO::WaitReadable
     @output = ""
  end

  def stop
    @server.close if @server
  end

  def game_script(game)
    until game.winner do
      can_play_round?(game) 
      game.play_round
      send_players_message(game,game.round_info)
    end
    puts "Winner: #{game.winner.name}"
  end

  def send_players_message(game,message)
    @game_with_players[game]['player1'].client.puts(message) 
    @game_with_players[game]['player2'].client.puts(message)
  end

  def send_player_message_expect_response(game,player,message)
    @game_with_players[game][player].client.puts(message)
    output = ""
    until output != "" do 
      output = capture_output(game,player)
    end
    output
  end

end







#ServerRunnerScript
war_server = WarSocketServer.new()
war_server.start 
while true
    war_server.accept_new_client("player #{war_server.players.count + 1}")
    war_game = war_server.create_game_if_possible
    if war_game
      Thread.new(war_game) do |game|
        game.start
        war_server.game_script(game)
      end
    end
end
war_server.players.each do |player|
    player.client.close
end
war_server.stop