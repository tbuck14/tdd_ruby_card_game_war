require 'socket'
require_relative 'war_socket_server'
require_relative 'war_game'
require_relative 'war_player'
require_relative 'card_deck'
require_relative 'playing_card'
require_relative 'war_server_runner'


client = TCPSocket.new('localhost',3336)
puts "hello! and welcome to a game of war"
loop do 
    message = client.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    message = ""
    puts message if message == 'break' || message == 'yes' || message == 'play round?'
    if message == 'play round?'
        return_message = gets.chomp
        client.puts(return_message)
    end
    break if message == 'break'
end
