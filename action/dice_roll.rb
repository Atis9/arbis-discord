module Arbis::Action
  class DiceRoll
    def initialize(event)
      @event = event
    end

    def execute
      result = dice_roll(parse(@event.content))
      response = @event.send_message(result, false, nil, nil, nil, @event.message)
    rescue => e
      @event.send_message("#{e.class}\n#{e.message}", false, nil, nil, nil, @event.message)
    end

    private

    def dice_roll(message)
      dice = GamesDice.create(message)
      dice.roll

      dice.explain_result
    end

    def parse(message)
      message.gsub(/^.*\s+roll\s+/, "").gsub(/#.*/, "").gsub(/\/\/.*/, "").gsub(/\s/, "")
    end
  end
end
