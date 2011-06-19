module BlackLotus
  module Utilities
    module_function
    
    def cards_for_number(n)
      cards = [ ]
      while n > 0
        if n.even?
          n     /= 2
          cards.unshift("dbl")
        else
          n     -= 1
          cards.unshift("succ")
        end
      end
      ["zero"] + cards
    end
    
    def moves_for_number(number, slot)
      cards = cards_for_number(number)
      cards.reverse[0..-2]
           .map { |card| [[1, "K", slot], [1, "S", slot], [2, slot, card]] }
           .flatten
           .each_slice(3)
           .to_a + [[2, slot, cards[0]]]
    end
  end
end
