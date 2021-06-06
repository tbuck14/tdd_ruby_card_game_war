class Player
    attr_reader :war_player, :client
    attr_accessor :ready

    def initialize(warPlayer,client, player_ready)
        @war_player = warPlayer
        @client = client
        @ready = player_ready
    end
end