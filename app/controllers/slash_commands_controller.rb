class SlashCommandsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    string = ReceiveSlashCommand.call(params)

    if string.present?
      render plain: string
    else
      head :ok
    end
  end
end
