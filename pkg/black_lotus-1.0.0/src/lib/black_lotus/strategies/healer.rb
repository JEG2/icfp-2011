module BlackLotus
  module Strategies
    module Healer
      def setup
        @to_heal       = game.propponent.weakest_slot   { |slot| slot.index }
        @heal_from     = game.propponent.strongest_slot { |slot| slot.index }
        @function_from = game.propponent.slots[9]
        @heal_amount   = [ ((MAX_FIELD - @to_heal.vitality) / 1.1).floor,
                           @heal_from.vitality - 1 ].min

        transition_to(:build_heal_from_index)

        [2, @function_from.index, "help"]
      end
      
      def build_heal_from_index
        transition_to(:build_to_heal_index)
        queue_moves( *Utilities.moves_for_number( @heal_from.index,
                                                  @function_from.index ) ).shift
      end
      
      def build_to_heal_index
        transition_to(:build_heal_amount)
        queue_moves( *Utilities.moves_for_number( @to_heal.index,
                                                  @function_from.index ) ).shift
      end
      
      def build_heal_amount
        transition_to(:setup)
        queue_moves( *Utilities.moves_for_number( @heal_amount,
                                                  @function_from.index ) ).shift
      end
    end
  end
end
