require 'celluloid/io'

class SlackClient
  attr_accessor :id
  delegate :start!, :web_client, to: :rt_client
  delegate :auth_test, to: :web_client

  def initialize
    rt_client.on :message, &method(:on_message)
  end

  private

  def on_message(msg)
    return unless for_bot?(msg)

    service, args = ParseMessage.call(message: msg.text)
    result = service.call(*args)

    return if result.blank?

    if result[:reaction]
      web_client.reactions_add(
        name: result[:reaction],
        channel: msg.channel,
        timestamp: msg.ts
      )
    end

    if result[:ephemeral]
      web_client.chat_postEphemeral(
        channel: msg.channel,
        user: msg.user,
        as_user: true,
        text: result[:ephemeral]
      )
    end
  end

  def rt_client
    @rt_client ||= Slack::RealTime::Client.new
  end

  def for_bot?(msg)
    msg.text&.include?("<@#{id}>")
  end
end
