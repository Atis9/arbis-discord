Arbis::Handler.add do |client|
  client.mention(contains: 'ping') do |event|
    action = Arbis::Action::PingPong.new(event)
    action.execute
  end
end
