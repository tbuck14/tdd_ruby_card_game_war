require 'socket'

class WarSocketServer
    attr_reader :games, :clients, :output
  def initialize
    @games = []
    @clients = []
  end

  def port_number
    3336
  end

  def welcome_message
    clients.each do |client|
        client['client'].puts('welcome')
    end
  end

  def start
    puts "Server Started!"
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    player = WarPlayer.new(player_name)
    @clients.push({'player'=>player, 'client'=>client})
    puts "Client #{player_name} Connected!"
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if @clients.length == 2
       game = WarGame.new(@clients[0]['player'], @clients[1]['player'])
       @games.push(game)
       return game
    else
       return false
    end
  end

  def play_round(player_one_answer, player_two_answer) 
    if player_one_answer == 'yes' && player_two_answer == 'yes'
        return true
    else
        return false
    end
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @clients.each do |client|
        @output = client['client'].read_nonblock(1000).chomp # not gets which blocks
        rescue IO::WaitReadable
        @output = ""
    end
  end

  def stop
    @server.close if @server
  end
end