require 'commands/play_sound'
require 'get_random_sound'

module Commands
  class Random
    def self.call(*args)
      new(*args).call
    end

    def initialize(args=nil)
      @args = args
    end

    def call
      PlaySound.call(message)

      { reaction: 'troll' }
    end

    private

    def message
      msg = GetRandomSound.call

      return msg unless @args.present?

      '%s %s' % [ msg, @args ]
    end
  end
end
