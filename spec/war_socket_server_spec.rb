require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
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

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
    @server.start
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  def make_and_accept_client()
    client = MockWarSocketClient.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client()
    client
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    client1 = make_and_accept_client
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = make_and_accept_client
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end
  it 'sends messages to the client' do  
    client1 = make_and_accept_client
    client2 = make_and_accept_client
    @server.welcome_message
    client1.capture_output(0)
    expect(client1.output).to(eq('welcome'))
    client2.capture_output(1)
    expect(client2.output).to(eq('welcome'))
  end
  it 'recieves messages from client' do  
    client1 = make_and_accept_client
    client1.provide_input('hello craig')
    @server.capture_output(0) #the 0 represents the client number
    expect(@server.output).to(eq('hello craig'))
  end
  it 'plays a round if both players are ready' do 
    client1 = make_and_accept_client
    @server.players[0].ready = true
    client2 = make_and_accept_client
    @server.players[1].ready = true
    expect(@server.can_play_round?).to(eq(true))
  end
  it 'does not play if one of the players is not ready' do 
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    @server.players[0].ready = true
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    expect(@server.can_play_round?).to(eq(false))
  end
  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end