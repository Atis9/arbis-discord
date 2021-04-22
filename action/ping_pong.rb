module Arbis::Action
  class PingPong
    def initialize(event)
      @event = event
    end

    def execute
      begin
        pp @event.content
        response = @event.send_message('pong', false, nil, nil, nil, @event.message)
        response.edit "#{response.content}\nTime taken: #{response.timestamp - @event.timestamp} seconds."
      rescue => e
        @event.send_message("#{e.class}\n#{e.message}", false, nil, nil, nil, @event.message)
      end
    end
  end
end
