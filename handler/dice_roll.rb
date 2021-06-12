Arbis::Handler.add do |client|
  client.mention(contains: /\s+roll\s+/) do |event|
    action = Arbis::Action::DiceRoll.new(event)
    action.execute
  end
end
