class Player
    attr_reader :war_player, :client
    attr_accessor :ready

    def initialize(warPlayer,socket, player_ready)
        @war_player = warPlayer
        @client = socket
        @ready = player_ready
    end
end