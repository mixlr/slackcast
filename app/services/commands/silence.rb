require 'send_to_browser'

module Commands
  class Silence
    def self.call
      new.call
    end

    def call
      SendToBrowser.call(:silence)

      { reaction: 'mute' }
    end
  end
end
