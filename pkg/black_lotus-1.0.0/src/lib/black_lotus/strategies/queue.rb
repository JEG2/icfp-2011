module BlackLotus
  module Strategies
    module Queue
      def move
        next_move or [1, "I", 0]
      end
      
      private
      
      def queue
        @q ||= number.zero? && ENV["QUEUE"] ? open(ENV["QUEUE"]) : false
      end
      
      def next_move
        if queue and (move = queue.gets)
          inputs = move.strip.split(",").map { |i| i =~ /\A\d+\z/ ? i.to_i : i }
          return inputs if inputs.size == 3
        end
      end
    end
  end
end
