class GetDropboxLink
  def self.call(basename)
    new(basename).call
  end

  def initialize(basename)
    @basename = basename
  end

  def call
    path = "#{root_path}/#{@basename}"
    client.get_temporary_link(path).last
  rescue Dropbox::ApiError
  end

  protected


  def root_path
    ENV['DROPBOX_ROOT_PATH']
  end

  def client
    @client ||= Dropbox::Client.new(ENV['DROPBOX_API_TOKEN'])
  end
end
