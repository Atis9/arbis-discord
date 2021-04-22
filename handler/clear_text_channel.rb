Arbis::Handler.add do |client|
  client.mention(contains: /@.+\sclear$/) do |event|
    action = Arbis::Action::ClearTextChannel.new(event, leave_recent_messages_flag: true)
    action.execute
  end

  client.mention(contains: /@.+\sclear\s--force$/) do |event|
    action = Arbis::Action::ClearTextChannel.new(event, leave_recent_messages_flag: false)
    action.execute
  end
end
