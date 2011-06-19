require "test_helper"

class TestErrors < Test::Unit::TestCase
  def test_errors_are_namespaced
    assert(defined?(BlackLotus::Errors), "Errors module wasn't defined")
    assert( defined?(BlackLotus::Errors::EvaluationError),
            "Error wasn't namespaced" )
  end
  
  def test_errors_inherit_from_the_base_error
    assert( BlackLotus::Errors::EvaluationError < BlackLotus::Errors::Error,
            "Error didn't inherit from base" )
  end
end
