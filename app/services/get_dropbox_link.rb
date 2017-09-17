class GetDropboxLink
  include DropboxClient

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
end
