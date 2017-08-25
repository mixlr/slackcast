class GetCodeVersion
  def self.call
    return ENV['HEROKU_RELEASE_VERSION'] if ENV['HEROKU_RELEASE_VERSION']

    @code_version ||= SecureRandom.hex
  end
end
