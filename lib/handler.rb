module Arbis
  class Handler
    def self.add(&block)
      @@handlers ||= []
      @@handlers << block
    end

    def self.register(client)
      @@handlers.each do |handler|
        handler.call(client)
      end
    end
  end
end
