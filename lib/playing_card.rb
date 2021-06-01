 class PlayingCard
    
    def initialize(rank, suit)
        @rank = rank
        @suit = suit
    end

    def rank 
        @rank
    end

    def suit
        @suit
    end

    def value
        value_hash = {'2'=>2,'3'=>3,'4'=>4,'5'=>5,'6'=>6,'7'=>7,'8'=>8,'9'=>9,'10'=>10,'J'=>11,'Q'=>12,'K'=>13,'A'=>14}
        value_hash[@rank]
    end
 end
