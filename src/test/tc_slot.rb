require "test_helper"

class TestSlot < Test::Unit::TestCase
  def setup
    @slot = BlackLotus::Slot.new
  end
  
  def test_default_values_are_set
    assert_equal(BlackLotus::Slot::DEFAULT_VITALITY, @slot.vitality)
    assert_equal(BlackLotus::Slot::DEFAULT_FIELD,    @slot.field)
  end
  
  def test_vitality_and_field_can_be_read
    assert_respond_to(@slot, :vitality)
    assert_respond_to(@slot, :field)
  end
  
  def test_field_can_be_updated
    assert_not_equal("zero", @slot.field)
    @slot.field = "zero"
    assert_equal("zero", @slot.field)
  end
  
  def test_attack_lowers_vitality
    vitality = @slot.vitality
    amount   = rand(10)
    @slot.attack(amount)
    assert_equal(vitality - amount, @slot.vitality)
  end
  
  def test_attacks_cannot_go_below_zero
    assert_equal(0, @slot.attack(@slot.vitality + 1))
  end
  
  def test_heal_raises_vitality
    vitality = @slot.vitality
    amount   = rand(10)
    @slot.heal(amount)
    assert_equal(vitality + amount, @slot.vitality)
  end
  
  def test_heal_cannot_go_above_max_vitality
    assert_equal( BlackLotus::MAX_VITALITY,
                  @slot.heal(BlackLotus::MAX_VITALITY + 1) )
  end
  
  def test_zombify
    assert_not_equal(-1, @slot.vitality)
    @slot.zombify
    assert_equal(-1, @slot.vitality)
  end
  
  def test_dezombify
    @slot.zombify
    assert_equal(-1, @slot.vitality)
    @slot.dezombify
    assert_equal(0, @slot.vitality)
  end
  
  def test_vitality_above_zero_is_alive
    assert(@slot.alive?, "A vitality above zero wasn't alive")
    assert(!@slot.dead?, "A vitality above zero was dead")
    @slot.attack(@slot.vitality - 1)
    assert(@slot.alive?, "A vitality above zero wasn't alive")
    assert(!@slot.dead?, "A vitality above zero was dead")
  end
  
  def test_vitality_of_zero_or_less_is_dead
    @slot.attack(@slot.vitality)
    assert(!@slot.alive?, "Vitality zero was alive")
    assert(@slot.dead?,   "Vitality zero wasn't dead")
    @slot.zombify
    assert(!@slot.alive?, "Vitality zero was alive")
    assert(@slot.dead?,   "Vitality zero wasn't dead")
  end
end
