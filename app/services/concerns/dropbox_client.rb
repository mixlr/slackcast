module DropboxClient
  protected

  def root_path
    Slackcast::Application.config.x.dropbox.root_path
  end

  def client
    Dropbox::Client.new(Slackcast::Application.config.x.dropbox.api_token)
  end
end
