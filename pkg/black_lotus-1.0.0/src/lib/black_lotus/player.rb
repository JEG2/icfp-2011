module BlackLotus
  class Player
    def initialize(number, game)
      @number     = number
      @game       = game
      @slots      = Array.new(MAX_SLOT + 1) { |i| Slot.new(i) }
      @turn       = 1
      @move_stack = [ ]
      @move_state = :setup
    end
    
    attr_reader :number, :game, :slots, :turn
    
    def alive?
      slots.any?(&:alive?)
    end
    
    def dead?
      not alive?
    end
    
    def end_turn
      @turn += 1
    end
    
    def active_slots
      slots.map.with_index { |slot, i|
        unless slot.vitality == 10_000 and slot.field == "I"
          "#{i}={#{slot.vitality},#{slot.field}}\n" 
        end
      }.compact
    end
    
    def move
      return @move_stack.shift unless @move_stack.empty?
      send(@move_state)
    end
    
    def transition_to(state)
      @move_state = state
    end
    
    def queue_moves(*moves)
      @move_stack.push(*moves)
    end
    
    def weakest_slot(*excludes)
      slots.reject { |slot| excludes.include? slot.index }.min_by { |slot|
        comparison = [slot.vitality]
        comparison.push(*yield(slot)) if block_given?
        comparison
      }
    end
    
    def strongest_slot(*excludes)
      slots.reject { |slot| excludes.include? slot.index }.max_by { |slot|
        comparison = [slot.vitality]
        comparison.push(*yield(slot)) if block_given?
        comparison
      }
    end
  end
end
