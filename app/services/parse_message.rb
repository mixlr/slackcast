require 'commands/silence'
require 'commands/play_sound'
require 'commands/random'

class ParseMessage
  # Example: <@U6WBCEV61>
  SLACK_TAG_REGEX = /<@\w+>/.freeze

  DEFAULT_SERVICE = 'Commands::PlaySound'

  def self.call(**args)
    new(**args).call
  end

  def initialize(message:)
    @message = message.gsub(SLACK_TAG_REGEX, '').strip
  end

  def call
    service || default_service
  end

  private
  attr_reader :message

  def service
    command, args = message.strip.split(/\s+/, 2)
    return unless services.include?(command)

    const = "Commands::#{command.camelize}"
    [ const.constantize, Array.wrap(args) ]
  end

  def default_service
    [ DEFAULT_SERVICE.constantize, [message] ]
  end

  def services
    @services ||= Commands::constants.map { |const| const.to_s.underscore }
  end
end
