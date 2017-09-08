require 'celluloid/io'

class SlackClient
  delegate :start!, :web_client, to: :rt_client

  def initialize
    rt_client.on :message, &method(:on_message)
  end

  private

  def on_message(msg)
    if result = ParseMessage.call(message: msg.text, bot_ids: rt_client.users.keys)
      ActionCable.server.broadcast(CastChannel::NAME, result)
      web_client.reactions_add(name: '+1', channel: msg.channel, timestamp: msg.ts)
    else
      Rails.logger.warn("Not processing message: #{msg.text}")
    end
  rescue ParseMessage::SoundNotFoundError => e
    web_client.reactions_add(name: '-1', channel: msg.channel, timestamp: msg.ts)
    post_ephemeral(text: "Hmmm. _#{e.sound}_ could not be located!", channel: msg.channel, user: msg.user)
  end

  def rt_client
    @rt_client ||= Slack::RealTime::Client.new
  end

  def post_ephemeral(text:, channel:, user:)
    web_client.chat_postEphemeral(
      channel: channel,
      user: user,
      as_user: true,
      text: text
    )
  end
end
