module Arbis::Action
  class ClearTextChannel
    class NowProcessingError < StandardError; end
    class NoPermissionError < StandardError; end

    NEED_PERMISSION = :manage_channels

    def initialize(event, options={})
      @event = event
      @user = event.author
      @channel_id = event.channel.id
      @response_message
      @leave_recent_messages_flag = !!options[:leave_recent_messages_flag]
      @@processing_channel_ids ||= []
    end

    def execute
      begin
        start_at = Time.now
        check_now_processing
        check_permission

        create_or_update_response_message("👌Start.")
        @@processing_channel_ids.append(@channel_id)

        create_or_update_response_message("⌛Processing...")
        delete_all(before_id)

        end_at = Time.now
        create_or_update_response_message("✅Finish.\nTime taken: #{end_at - start_at} seconds.")
      rescue => e
        create_or_update_response_message("#{e.class}")
      ensure
        @@processing_channel_ids.delete(@channel_id)
      end
    end

    private

    def check_now_processing
      return if @@processing_channel_ids.find {|id| id == @channel_id }.blank?

      raise NowProcessingError
    end

    def check_permission
      return if @user.permission?(NEED_PERMISSION, @event.channel)

      raise NoPermissionError
    end

    def create_or_update_response_message(text)
      text = text.slice(0, 2000) if text.size > 2000

      if @response_message.blank?
        @response_message = @event.send_message(text, false, nil, nil, nil, @event.message)
      else
        @response_message = @response_message.edit(text)
      end
    rescue RestClient::BadRequest
      @response_message = @event.send_message(text)
    end

    def delete_all(before_id=nil)
      before_id ||= @event.message.id

      loop do
        messages = @event.channel.history(100, before_id)
        break if messages.size.zero?

        messages.each(&:delete)
      end
    rescue RestClient::BadRequest
      loop do
        messages = @event.channel.history(100, before_id)
        break if messages.size.zero?

        @event.channel.delete_messages(messages)
      end
    end

    def before_id
      if @leave_recent_messages_flag
        @event.channel.history(100, @event.message.id).min {|m1, m2| m1.timestamp <=> m2.timestamp }.id
      else
        nil
      end
    end
  end
end
