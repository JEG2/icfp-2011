module BlackLotus
  class Duel
    def initialize(player_number, player_strategy, log = nil)
      @players = Array.new(2) { |i|
        player = Player.new(i, self)
        player.extend( i == player_number ? player_strategy :
                                            Strategies::Opponent )
        player
      }
      @log     = log && open(log, "a")
    end
    
    attr_reader :log
    
    def propponent
      @players.first
    end
    
    def opponent
      @players.last
    end
    
    def end_turn
      @players.reverse!
    end
    
    def run_turn
      run_zombies
      move = propponent.move
      puts move unless propponent.is_a? Strategies::Opponent
      Evaluator.new(self).apply(move)
      if log
        log.puts "Player #{propponent.number}'s move #{propponent.turn}: %p" %
                 [move]
        @players.each do |player|
          log.puts "--"
          unless (active = player.active_slots).empty?
            log.puts player.active_slots
          end
        end
        log.puts
      end
      propponent.end_turn
      end_turn
    end
    
    def run
      until over?
        run_turn
      end
      if log
        log.puts @players.map { |player| player.slots.count(&:alive?) }
                         .join(":")
      end
    end
    
    def over?
      @players.any?(&:dead?) or
      @players.all? { |player| player.turn > MAX_TURN }
    end
    
    private
    
    def run_zombies
      propponent.slots.each_with_index do |slot, i|
        if slot.zombie?
          Evaluator.new(self, :zombie_move).apply([2, i, "I"])
          slot.field = "I"
          slot.dezombify
        end
      end
    end
  end
end
