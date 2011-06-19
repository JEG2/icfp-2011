module BlackLotus
  module Errors
    class Error           < RuntimeError; end
    class EvaluationError < Error;        end
  end
end
