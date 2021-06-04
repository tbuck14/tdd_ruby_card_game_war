require 'socket'
require_relative '../lib/war_socket_client'
require_relative '../lib/war_socket_server'

describe "#WarSocketClient" do 

  before(:each) do
    @server = WarSocketServer.new
    @clients = []
  end

  after(:each) do
    @clients.each do |client|
        client.close
    end
    @server.stop
  end

  #capture_output
  it 'recieves output from the server' do 
    @server.start
    client = WarSocketClient.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
    @server.players[0].client.puts('welcome')
    expect(client.capture_output).to(eq('welcome'))
  end

   #provide_input
   it 'sends messages to the server' do 
     @server.start
     client = WarSocketClient.new(@server.port_number)
     @clients.push(client)
     @server.accept_new_client
     client.provide_input('thank you')
     expect(@server.capture_output(0)).to(eq('thank you'))
   end
end

