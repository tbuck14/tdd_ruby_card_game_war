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
    @server.stop #had to stop the server before testing, becuase in my before each I make and start the server everytime
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
    client1.capture_output
    client2.capture_output
    @server.welcome_message
    expect(client1.capture_output).to(eq('welcome'))
    expect(client2.capture_output).to(eq('welcome'))
  end
  it 'recieves messages from client' do  
    client1 = make_and_accept_client
    client2 = make_and_accept_client
    game = @server.create_game_if_possible
    client1.provide_input('hello craig')
    @server.capture_output(game,'player1')
    expect(@server.output).to(eq('hello craig'))
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end