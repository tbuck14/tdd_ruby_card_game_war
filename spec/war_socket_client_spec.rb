require 'socket'
require_relative '../lib/war_socket_client'
require_relative '../lib/war_socket_server'
require_relative '../lib/player'

describe "#WarSocketClient" do 

  before(:each) do
    @server = WarSocketServer.new
    @server.start
    @clients = []
  end

  after(:each) do
    @clients.each do |client|
        client.close
    end
    @server.stop
  end

  def set_up_game()
    2.times do 
      client = WarSocketClient.new(@server.port_number)
      @clients.push(client)
      @server.accept_new_client
    end
    game = @server.create_game_if_possible
  end
  #capture_output
  it 'recieves output from the server' do 
    client = WarSocketClient.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
    client.capture_output  #clear the previous output of welcoming the player on arrival
    @server.players[0].client.puts('welcome')
    expect(client.capture_output).to(eq('welcome'))
  end

   #provide_input
   it 'sends messages to the server' do 
      server = TCPServer.new(3337)
      new_client = WarSocketClient.new(3337)
      client = server.accept_nonblock
      new_client.provide_input('hello world')
      expect(client.gets.chomp).to(eq('hello world'))
      client.close
      server.close
   end
end

