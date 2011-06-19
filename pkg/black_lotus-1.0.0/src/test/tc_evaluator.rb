require "test_helper"

class TestEvaluator < Test::Unit::TestCase
  # def test_identity
  #   assert_equal(1,   apply("I", 1))
  #   assert_equal(2,   apply("I", 2))
  #   assert_equal("I", apply("I", "I"))
  # end
  # 
  # def test_succ
  #   assert_equal(1,   apply("succ", 0))
  #   assert_equal(1,   apply("succ", "zero"))
  #   assert_equal(MAX, apply("succ", MAX))
  # end
  # 
  # def test_zero
  #   assert_equal("zero", apply("I",    "zero"))
  #   assert_equal(1,      apply("succ", "zero"))
  #   assert_equal(0,      apply("dbl",  "zero"))
  # end
  # 
  # def test_dbl
  #   assert_equal(2,   apply("dbl", 1))
  #   assert_equal(MAX, apply("dbl", 32768))
  # end
end
