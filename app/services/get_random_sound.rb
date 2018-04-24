class GetRandomSound
  include DropboxClient

  def self.call
    new.call
  end

  def call
    path = folder.sample.try(:path_lower)

    return unless path

    client.get_temporary_link(path).last
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
