class CastChannel < ApplicationCable::Channel
  def subscribed
    stream_from ReceiveSlashCommand::CHANNEL
  end

  def unsubscribed
  end
end
