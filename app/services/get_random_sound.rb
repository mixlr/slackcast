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
    @folder ||= client.list_folder(root_path)
  end
end
