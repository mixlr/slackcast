class CastChannel < ApplicationCable::Channel
  NAME = 'cast_notifications'.freeze

  before_subscribe :check_code_version

  def subscribed
    stream_from NAME
  end

  def unsubscribed
  end

  private

  def check_code_version
    reject unless params[:code_version] == GetCodeVersion.call
  end
end
