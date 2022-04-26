class GetRandomSound
  include DropboxClient

  def self.call
    new.call
  end

  def call
    f = folder.sample&.name
    File.basename(f, File.extname(f))
  end

  private

  def folder
    @folder ||= begin
      client.list_folder(root_path)
    rescue Dropbox::ApiError => e
      Rails.logger.warn("Dropbox folder listing error: #{e.message}")
      []
    end
  end
end
