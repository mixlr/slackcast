require 'celluloid/io'

class SlackClient
  attr_accessor :id
  delegate :start!, :web_client, to: :rt_client
  delegate :auth_test, to: :web_client

  def initialize
    rt_client.on :hello,   &method(:on_hello)
    rt_client.on :close,   &method(:on_close)
    rt_client.on :closed,  &method(:on_closed)
    rt_client.on :message, &method(:on_message)
  end

  private

  def on_hello(msg)
    Rails.logger.info "Connected to %s as %s" % [rt_client.team.name, rt_client.self.name]
  end

  def on_close(data)
    Rails.logger.info "About do disconnect from %s" % rt_client.team.name
  end

  def on_closed(data)
    Rails.logger.info "Disconnected from %s" % rt_client.team.name
  end

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
