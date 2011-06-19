module BlackLotus
  class Slot
    DEFAULT_VITALITY = 10_000
    DEFAULT_FIELD    = "I"
    
    def initialize(index, vitality = DEFAULT_VITALITY, field = DEFAULT_FIELD)
      @index    = index
      @vitality = vitality
      @field    = field
    end

    attr_reader   :index, :vitality
    attr_accessor :field
    
    def attack(vitality)
      @vitality = [0, @vitality - vitality].max
    end
    
    def heal(vitality)
      @vitality = [MAX_VITALITY, @vitality + vitality].min
    end
    
    def zombify
      @vitality = -1
    end
    
    def dezombify
      @vitality = 0
    end
    
    def zombie?
      @vitality == -1
    end

    def alive?
      @vitality > 0
    end

    def dead?
      not alive?
    end
  end
end
