require "test_helper"

class TestDuel < Test::Unit::TestCase
  module TestStrategy
    MOVE_QUEUE = [ ]
    
    
  end
  
  def test_propponent_returns_the_current_player
    assert_equal(0, BlackLotus::Duel.new(0, TestStrategy).propponent.number)
  end
  
  def test_opponent_returns_the_next_player
    assert_equal(1, BlackLotus::Duel.new(0, TestStrategy).opponent.number)
  end
  
  def test_the_indicated_player_gets_the_indicated_strategy
    assert_kind_of( TestStrategy,
                    BlackLotus::Duel.new(0, TestStrategy).propponent )
    assert_kind_of( TestStrategy,
                    BlackLotus::Duel.new(1, TestStrategy).opponent )
  end
  
  def test_the_other_player_is_an_opponent
    assert_kind_of( BlackLotus::Strategies::Opponent,
                    BlackLotus::Duel.new(0, TestStrategy).opponent )
    assert_kind_of( BlackLotus::Strategies::Opponent,
                    BlackLotus::Duel.new(1, TestStrategy).propponent )
  end
  
  def test_end_turn_moves_to_the_next_player
    duel         = BlackLotus::Duel.new(0, TestStrategy)
    first_player = duel.propponent
    last_player  = duel.opponent
    duel.end_turn
    assert_equal(last_player,  duel.propponent)
    assert_equal(first_player, duel.opponent)
  end
end
