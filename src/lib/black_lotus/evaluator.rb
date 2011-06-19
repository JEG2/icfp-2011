module BlackLotus
  class Evaluator
    def initialize(game, zombie_move = false)
      @game         = game
      @applications = 0
      @zombie_move  = !!zombie_move
    end
    
    attr_reader :game
    
    def zombie_move?
      @zombie_move
    end
    
    def apply(move)
      direction    = move[0]
      card, slot_i = move[1..-1].send(direction == 1 ? :to_a : :reverse)
      slot         = game.propponent.slots[validate(slot_i)]
      f, x         = [card, slot.field].send(direction == 1 ? :to_a : :reverse)
      begin
        slot.field = evaluate(f, x)
      rescue Errors::EvaluationError
        slot.field = "I"
      end
    end

    def I(x)
      x
    end

    def succ(n)
      max(numify(n) + 1)
    end
    
    def dbl(n)
      max(numify(n) * 2)
    end
    
    def get(i)
      slot = game.propponent.slots[validate(i)]
      fail Errors::EvaluationError, "Slot dead" unless slot.alive?
      slot.field
    end
    
    def put(x)
      "I"
    end
    
    def S(f, g = nil, x = nil)
      if g.nil?
        "S(#{f})"
      elsif x.nil?
        "S(#{f})(#{g})"
      else
        h = evaluate(f, x)
        y = evaluate(g, x)
        evaluate(h, y)
      end
    end
    
    def K(x, y = nil)
      if y.nil?
        "K(#{x})"
      else
        x
      end
    end
    
    def inc(i)
      slot = game.propponent.slots[validate(i)]
      if zombie_move?
        slot.attack(1) if slot.alive?
      else
        slot.heal(1) if slot.alive?
      end
      "I"
    end
    
    def dec(i)
      slot = game.opponent.slots[255 - validate(i)]
      if zombie_move?
        slot.heal(1) if slot.alive?
      else
        slot.attack(1) if slot.alive?
      end
      "I"
    end
    
    def attack(i, j = nil, n = nil)
      if j.nil?
        "attack(#{i})"
      elsif n.nil?
        "attack(#{i})(#{j})"
      else
        slot = game.propponent.slots[validate(i)]
        n    = numify(n)
        if n > slot.vitality
          fail Errors::EvaluationError, "Not enough vitality"
        end
        slot.attack(n)
        slot = game.opponent.slots[255 - validate(j)]
        if zombie_move?
          slot.heal(n * 9 / 10)
        else
          slot.attack(n * 9 / 10)
        end
        "I"
      end
    end
    
    def help(i, j = nil, n = nil)
      if j.nil?
        "help(#{i})"
      elsif n.nil?
        "help(#{i})(#{j})"
      else
        slot = game.propponent.slots[validate(i)]
        n    = numify(n)
        if n > slot.vitality
          fail Errors::EvaluationError, "Not enough vitality"
        end
        slot.attack(n)
        slot = game.propponent.slots[validate(j)]
        if zombie_move?
          slot.attack(n * 11 / 10)
        else
          slot.heal(n * 11 / 10)
        end
        "I"
      end
    end
    
    def copy(i)
      slot = game.opponent.slots[255 - validate(i)]
      slot.field
    end
    
    def revive(i)
      slot = game.propponent.slots[validate(i)]
      if slot.dead?
        if slot.zombie?
          slot.dezombify
        end
        slot.heal(1)
      end
      "I"
    end
    
    def zombie(i, x = nil)
      if x.nil?
        "zombie(#{i})"
      else
        slot = game.opponent.slots[255 - validate(i)]
        unless slot.dead?
          fail Errors::EvaluationError, "Slot not dead"
        end
        slot.field = x
        slot.zombify
        "I"
      end
    end
  
    private
  
    def max(n)
      [MAX_FIELD, n].min
    end
  
    def numify(n)
      if n == "zero"
        0
      else 
        if n.is_a? Integer
          n
        else
          fail Errors::EvaluationError, "Not a number"
        end
      end
    end
  
    def validate(i)
      n = numify(i)
      unless n.between? 0, MAX_SLOT
        fail Errors::EvaluationError, "Not a valid slot"
      end
      n
    end
    
    def evaluate(f, x)
      count_application
      
      args  = f =~ /\A\w+\(/ ? f.scan(/(?<arg>\((?:[^()]|\g<arg>)*\))/)
                                .flatten
                                .map { |arg| arg[1..-2] }
                                .map { |i| i =~ /\A\d+\z/ ? i.to_i : i } : [ ]
      args << x
      
      if f.is_a?(Integer) || f == "zero"
        fail Errors::EvaluationError, "Not a function"
      else
        send(f[/\A\w+/], *args)
      end
    end
    
    def count_application(applications = 1)
      @applications += applications
      if @applications > MAX_APPLICATIONS
        fail Errors::EvaluationError, "Application limit exceeded"
      end
    end
    alias_method :count_applications, :count_application
  end
end
