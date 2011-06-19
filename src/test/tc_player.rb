require "test_helper"

class TestPlayer < Test::Unit::TestCase
  def setup
    @number = rand(2)
    @player = BlackLotus::Player.new(@number)
  end
  
  def test_number_can_be_read
    assert_equal(@number, @player.number)
  end
  
  def test_players_are_initialized_with_a_full_set_of_slots
    assert_equal(BlackLotus::MAX_SLOT + 1, @player.slots.size)
    assert( @player.slots.all? { |slot| slot.is_a?(BlackLotus::Slot) },
            "Not all slots were initialized" )
  end
  
  def test_players_are_alive_until_all_of_their_slots_are_dead
    @player.slots.each do |slot|
      assert(slot.alive?,    "Slot was already dead")
      assert(@player.alive?, "Player wasn't alive")
      assert(!@player.dead?, "Player was dead")
      slot.attack(slot.vitality)
    end
    assert(!@player.alive?, "Player was alive")
    assert(@player.dead?,   "Player wasn't dead")
  end
  
  def test_turns_start_counting_at_one
    assert_equal(1, @player.turn)
  end
  
  def test_end_turn_advances_the_turn_counter
    assert_equal(2, @player.end_turn)
  end
end
