module BlackLotus
  module Strategies
    module Opponent
      def move
        direction = $stdin.gets.to_i
        left      = $stdin.gets.strip
        right     = $stdin.gets.strip
        if direction == 1
          right = right.to_i
        else  # 2
          left = left.to_i
        end
        [direction, left, right]
      end
    end
  end
end
