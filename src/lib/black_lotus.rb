module BlackLotus
  MAX_FIELD        = 65_535
  MAX_VITALITY     = 65_535
  MAX_SLOT         = 255
  MAX_TURN         = 100_000
  MAX_APPLICATIONS = 1_000
end

require "black_lotus/errors"
require "black_lotus/utilities"
require "black_lotus/slot"
require "black_lotus/player"
require "black_lotus/duel"
require "black_lotus/evaluator"

# load all strategies
Dir.glob(File.join(File.dirname(__FILE__), *%w[black_lotus strategies *.rb]))
   .each do |path|
  require File.join(File.dirname(path), File.basename(path, ".rb"))
end
