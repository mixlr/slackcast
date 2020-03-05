module DropboxClient
  protected

  # Returns the root path from the App base directory (Dropbox/Apps/Mixlr Slackcast)
  # note: use '' instead of '/' when targeting the root folder
  def root_path
    ''
  end

  def client
    Dropbox::Client.new(Slackcast::Application.config.x.dropbox.api_token)
  end
end
