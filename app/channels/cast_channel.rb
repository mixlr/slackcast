class CastChannel < ApplicationCable::Channel
  before_subscribe :check_code_version

  def subscribed
    stream_from ReceiveSlashCommand::CHANNEL
  end

  def unsubscribed
  end

  private

  def check_code_version
    reject unless params[:code_version] == GetCodeVersion.call
  end
end
