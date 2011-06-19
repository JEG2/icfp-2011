require "test_helper"

class TestConstants < Test::Unit::TestCase
  def test_code_is_namespaced
    assert(defined?(BlackLotus),       "Namespace module wasn't defined")
    assert(defined?(BlackLotus::Slot), "Class wasn't namespaced")
  end
  
  def test_maximums_at_set
    assert_kind_of(Integer, BlackLotus::MAX_FIELD)
    assert_kind_of(Integer, BlackLotus::MAX_VITALITY)
    assert_kind_of(Integer, BlackLotus::MAX_SLOT)
  end
end
