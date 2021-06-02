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
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end
  it 'sends messages to the client' do 
    @server.start 
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('trevor')
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client('trevor new')
    @server.welcome_message
    client1.capture_output
    expect(client1.output).to(eq('welcome'))
    client2.capture_output
    expect(client2.output).to(eq('welcome'))
  end
  it 'recieves messages from client' do 
    @server.start 
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client('trevor')
    client1.provide_input('hello craig')
    @server.capture_output
    expect(@server.output).to(eq('hello craig'))
  end
  it 'plays a round if both players are ready' do 
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    client2 = MockWarSocketClient.new(@server.port_number)
    expect(@server.play_round('yes','yes')).to(eq(true))
  end
  it 'does not play if one of the players is not ready' do 
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    client2 = MockWarSocketClient.new(@server.port_number)
    expect(@server.play_round('yes','no')).to(eq(false))
  end
  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end