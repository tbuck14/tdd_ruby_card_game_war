require 'socket'
# require_relative 'war_game'
# require_relative 'war_player'
# require_relative 'card_deck'
# require_relative 'playing_card'
# require_relative 'player'


class WarSocketClient 
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end











#CLIENT RUNNER SCRIPT

client = WarSocketClient.new(3336)
loop do 
    server_message = ""
    until server_message != ""
        server_message = client.capture_output
    end
    response = ""
    loop do
        puts server_message
        response = gets.chomp
        if response == 'yes'
            client.provide_input(response)
            break
        end
    end
end
