require 'celluloid/io'

class SlackClient
  delegate :start!, to: :rt_client

  def initialize
    rt_client.on :message, &method(:on_message)
  end

  private

  def on_message(msg)
    if result = ParseMessage.call(message: msg.text, bot_ids: rt_client.users.keys)
      ActionCable.server.broadcast(CastChannel::NAME, result)
    else
      Rails.logger.warn("Not processing message: #{msg.text}")
    end
  end

  def rt_client
    @rt_client ||= Slack::RealTime::Client.new
  end
end
