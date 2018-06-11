require 'socket'
require 'war_game'

class WarSocketServer
  def initialize
  end

  def port_number
    3336
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    pending_clients.push(client)
    client.puts(pending_clients.count.odd? ? "Welcome.  Waiting for another player to join." : "Welcome.  You are about to go to war.")
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if pending_clients.count > 1
      game = WarGame.new
      games.push(game)
      games_to_humans[game] = pending_clients.shift(2)
      game.start
      inform_players_of_hand(game)
    end
  end

  def run_game(game)
    # spawn a thread
    game_runner = WarSocketGameRunner.new(game, games_to_humans(game))
    game_runner.start
  end

  def stop
    @server.close if @server
  end

  private

  def inform_players_of_hand(game)
    humans = games_to_humans[game]
    humans[0].puts("You have #{game.player1.cards_left} cards left")
    humans[1].puts("You have #{game.player2.cards_left} cards left")
  end

  def pending_clients
    @pending_clients ||= []
  end

  def games_to_humans
    @games_to_humans ||= {}
  end
end
