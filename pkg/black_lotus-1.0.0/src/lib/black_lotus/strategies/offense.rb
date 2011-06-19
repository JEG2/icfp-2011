module BlackLotus
  module Strategies
    module Offense
      attr_reader :used_slots
      
      def setup
        if need_healing?
          choose_heal_slots
          heal_slots
        elsif have_zombie_attack?
          choose_zombie_attack_slots
          zombie_attack_slots
        elsif have_attack?
          choose_attack_slots
          attack_slots
        else
          [1, "I", 0]
        end
      end
      
      # def can_transfer?
      #   trans_from = game.propponent
      #                       .slots
      #                       .find { |slot| slot.alive? and
      #                                      slot.vitality == MAX_VITALITY }
      #   trans_to   = trans_from && game.propponent.slots[trans_from.index + 1]
      #   if trans_from and trans_to and
      #      trans_to.alive? and trans_to.vitality < MAX_VITALITY
      #     @trans_from = trans_from
      #     @trans_to   = trans_to
      #     @old_target = nil
      #     true
      #   end
      # end
      # 
      # def choose_transfer_slots
      #   @used_slots        = {:number => game.propponent.slots.find(&:alive?)}
      #   @used_slots[:heal] = game.propponent.slots.find { |slot|
      #                          slot.alive? and
      #                          not @used_slots.values.include? slot
      #                        }
      #   @used_slots[:f]    = game.propponent.slots.find { |slot|
      #                          slot.alive? and
      #                          not @used_slots.values.include? slot
      #                        }
      #   @current_number    = { :number => used_slots[:number]           &&
      #                          used_slots[:number].field.is_a?(Integer) ?
      #                          used_slots[:number].field                :
      #                          nil,
      #                          :heal   => used_slots[:heal]           &&
      #                          used_slots[:heal].field.is_a?(Integer) ?
      #                          used_slots[:heal].field                :
      #                          nil }
      # end
      # 
      # def transfer
      #   queue_moves(
      #     *clear_to("S", used_slots[:f]),
      #     [2, used_slots[:f].index, "help"],
      #     [2, used_slots[:f].index, "succ"],
      #     *add_number_to(@trans_from.index, used_slots[:f]),
      #     *add_number_to( ((MAX_VITALITY - @trans_to.vitality) / 1.1 + 1).floor,
      #                     used_slots[:f],
      #                     :heal )
      #   ).shift
      # end
      
      def need_healing?
        # game.propponent.slots.any?  { |slot| slot.vitality <  10_000       } or
        # game.propponent.slots.none? { |slot| slot.vitality == MAX_VITALITY }
        game.propponent.slots.any?(&:dead?)
      end
      
      def choose_heal_slots
        @old_target          = defined?(@used_slots) && @used_slots[:target]
        @used_slots          = {:f => game.propponent.slots.find(&:alive?)}
        @used_slots[:number] = game.propponent.slots.find { |slot|
                                 slot.alive? and
                                 not @used_slots.values.include? slot
                               }
        @used_slots[:copy]   = game.propponent.slots.find { |slot|
                                 slot.alive? and
                                 not @used_slots.values.include? slot
                               }
        @current_number      = { :number => used_slots[:number]           &&
                                 used_slots[:number].field.is_a?(Integer) ?
                                 used_slots[:number].field                :
                                 nil }
      end
      
      def heal_slots
        used_slots[:target] = game.propponent.slots.find(&:dead?)
        # used_slots[:target] = game.propponent
        #                           .slots
        #                           .find { |slot| slot.vitality < MAX_VITALITY }
        if used_slots.values.compact.size == 4
          moves = [ ]
          unless used_slots[:target].alive?
            moves.push( *clear_to("revive", used_slots[:f]),
                        *add_number_to( used_slots[:target].index,
                                        used_slots[:f] ) )
          end
          # if used_slots[:target].vitality < 1_681
          #   moves.push( *clear_to("S", used_slots[:f]),
          #               [2, used_slots[:f].index, "inc"],
          #               [2, used_slots[:f].index, "get"],
          #               [1, "S", used_slots[:f].index],
          #               [2, used_slots[:f].index, "I"],
          #               [2, used_slots[:f].index, "zero"] )
          # else
          #   if not used_slots[:f].field.to_s.include?("help") or
          #      @old_target != used_slots[:target]
          #     moves.push( *clear_to("help", used_slots[:f]),
          #                  *add_number_to( used_slots[:target].index,
          #                                  used_slots[:f] ),
          #                  *add_number_to( used_slots[:target].index,
          #                                  used_slots[:f] ),
          #                  [1, "K", used_slots[:f].index],
          #                  [1, "S", used_slots[:f].index],
          #                  [2, used_slots[:f].index, "get"],
          #                  *Utilities.moves_for_number(
          #                    used_slots[:number].index,
          #                    used_slots[:f].index
          #                  )[0..-2] )
          #   end
          #   amount = [ used_slots[:target].vitality - 1,
          #              [9984, 19968, 39936].reject { |n|
          #                n >= used_slots[:target].vitality
          #              }.max ].compact.min
          #   if used_slots[:number].field != amount
          #     moves.push(*add_number_to(amount, used_slots[:number]))
          #   end
          #   moves.push( *clear_to("get", used_slots[:copy]),
          #               *Utilities.moves_for_number( used_slots[:f].index,
          #                                            used_slots[:copy].index ),
          #               [2, used_slots[:copy].index, "zero"] )
          # end
          queue_moves(*moves).shift
        else
          [1, "I", 0]
        end
      end
      
      def have_zombie_attack?
        target = game.opponent.slots.last(128).find(&:dead?)
        healer = target && game.opponent.strongest_slot(
                   target.index
                 ) { |slot| -slot.index }
        healed = target && healer && game.opponent.strongest_slot(
                   target.index,
                   healer.index
                 ) { |slot| -slot.index }
        if target and healer and healed and
           healer.alive? and healed.alive? and healer.vitality > 1
          @target     = target
          @healer     = healer
          @healed     = healed
          @old_target = nil
          true
        end
      end
      
      def choose_zombie_attack_slots
        @used_slots        = {:number => game.propponent.slots.find(&:alive?)}
        @used_slots[:f]    = game.propponent.slots.find { |slot|
                               slot.alive? and
                               not @used_slots.values.include? slot
                             }
        @used_slots[:heal] = game.propponent.slots.find { |slot|
                               slot.alive? and
                               not @used_slots.values.include? slot
                             }
        @used_slots[:inc]  = game.propponent.slots.find { |slot|
                               slot.alive? and
                               not @used_slots.values.include? slot
                             }
        @current_number    = { :number => used_slots[:number]           &&
                               used_slots[:number].field.is_a?(Integer) ?
                               used_slots[:number].field                :
                               nil }
      end
      
      def zombie_attack_slots
        queue_moves(
          *clear_to("help", used_slots[:heal]),
          *add_number_to(@healer.index, used_slots[:heal]),
          *clear_to("inc", used_slots[:inc]),
          [1, "K", used_slots[:inc].index],
          [1, "S", used_slots[:inc].index],
          [1, "K", used_slots[:inc].index],
          [1, "S", used_slots[:inc].index],
          [2, used_slots[:inc].index, "K"],
          *add_number_to(@healer.index, used_slots[:inc]),
          *add_number_to(@healed.index, used_slots[:heal]),
          [1, "K", used_slots[:heal].index],
          [1, "S", used_slots[:heal].index],
          [1, "K", used_slots[:heal].index],
          [1, "S", used_slots[:heal].index],
          [2, used_slots[:heal].index, "K"],
          *add_number_to(@healer.vitality - 1, used_slots[:heal]),
          [1, "S", used_slots[:heal].index],
          [1, "K", used_slots[:heal].index],
          [1, "S", used_slots[:heal].index],
          [2, used_slots[:heal].index, "get"],
          *add_number_to(used_slots[:inc].index, used_slots[:heal]),
          *clear_to("zombie", used_slots[:f]),
          *add_number_to(255 - @target.index, used_slots[:f]),
          [1, "K", used_slots[:f].index],
          [1, "S", used_slots[:f].index],
          [2, used_slots[:f].index, "get"],
          *add_number_to(used_slots[:heal].index, used_slots[:f])
        ).shift
      end
      
      def have_attack?
        source, extra_source = game.propponent
                                   .slots
                                   .sort_by { |slot| [ slot.index >= 4 ? 0 : 1,
                                                       slot.vitality ==
                                                         MAX_VITALITY ? 1 : 0,
                                                       -slot.vitality,
                                                       -slot.index ] }
                                   .first(2)
                                   .sort_by { |slot| slot.index }
        target               = game.opponent
                                   .slots
                                   .min_by { |slot| [ slot.alive? ? 0 : 1,
                                                      slot.vitality,
                                                      (255 - slot.index) ] }
        damage               = (target.vitality * 10 / 9 / 2.0).ceil
        if source and extra_source and target and
           source.vitality > damage and extra_source.vitality > damage
          @source       = source
          @extra_source = extra_source
          @target       = target
          @damage       = damage
          @old_target   = nil
          true
        end
      end
      
      def choose_attack_slots
        @used_slots        = {:std => game.propponent.slots.find(&:alive?)}
        @used_slots[:heal] = game.propponent.strongest_slot(
                               used_slots[:std].index
                             ) { |slot| -slot.index }
        @used_slots[:f]    = game.propponent.strongest_slot(
                               used_slots[:std].index,
                               used_slots[:heal].index,
                             ) { |slot| -slot.index }
        @current_number    = { :std => used_slots[:std]              &&
                               used_slots[:std].field.is_a?(Integer) ?
                               used_slots[:std].field                :
                               nil }
      end
      
      def attack_slots
        queue_moves(
          *clear_to("attack", used_slots[:f]),
          *add_number_to(@source.index, used_slots[:f], :std),
          *add_number_to(255 - @target.index, used_slots[:f], :std),
          [1, "S", used_slots[:f].index],
          [1, "K", used_slots[:f].index],
          [1, "S", used_slots[:f].index],
          [1, "K", used_slots[:f].index],
          [1, "S", used_slots[:f].index],
          [2, used_slots[:f].index, "attack"],
          *add_number_to(@extra_source.index, used_slots[:f], :std),
          *add_number_to(255 - @target.index, used_slots[:f], :std),
          *add_number_to(@damage, used_slots[:f], :std)
        ).shift
      end

      private
      
      def clear_to(card, slot, value = slot.field)
        if value == card
          [ ]
        elsif value == "I"
          [[2, slot.index, card]]
        else
          [[1, "put", slot.index], [2, slot.index, card]]
        end
      end
      
      def add_number_to(number, slot, scratch = :number)
        cards = Utilities.cards_for_number(number)
        moves = [ [2, used_slots[scratch].index, cards[0]],
                  *Array(cards[1..-1]).map { |card|
                    [1, card, used_slots[scratch].index]
                  } ]
        copy  = used_slots[scratch].index == slot.index ?
                [ ]                                     :
                [ [1, "K", slot.index],
                  [1, "S", slot.index],
                  [2, slot.index, "get"],
                  *Utilities.moves_for_number( used_slots[scratch].index,
                                               slot.index ) ]
        if number.zero?
          [[2, slot.index, "zero"]]
        elsif @current_number[scratch] and @current_number[scratch] <= number
          number_increase = [ ]
          n               = @current_number[scratch]
          while n < number
            if n * 2 <= number
              number_increase << [1, "dbl", used_slots[scratch].index]
              n               *= 2
            else
              (number - n).times do
                number_increase << [1, "succ", used_slots[scratch].index]
              end
              n += number - n
            end
          end
          number_increase.size < moves.size ?
            [*number_increase, *copy]       :
            [[1, "put", used_slots[scratch].index], *moves, *copy]
        else
          [ *clear_to( "zero",
                       used_slots[scratch],
                       @current_number[scratch] || used_slots[scratch].field ),
            *moves[1..-1],
            *copy ]
        end
      ensure
        @current_number[scratch] = number if number > 0
      end
    end
  end
end
