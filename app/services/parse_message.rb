class ParseMessage
  MP3             = '.mp3'.freeze
  NUMBER_REGEX    = /\A\d+(\.\d+)?\z/.freeze
  URI_REGEX       = /\Ahttps?:\/\//.freeze
  SLACK_URI_REGEX = /\A<http.*>\z/

  SoundNotFoundError  = Class.new(StandardError) do
    attr_reader :sound

    def initialize(sound)
      @sound = sound
    end
  end

  # Example: <@U6WBCEV61>
  SLACK_TAG_REGEX = /<@\w+>/.freeze

  # Example: Distortion Delay(some arguments)
  EFFECTS_REGEX = /(\w+)(?:\(([^)]*)\))?/.freeze

  # Example: feedback=3 wetLevel=0.2
  EFFECT_REGEX = /(\w+)\s*[=:]\s*([\d+.]+)/.freeze

  def self.call(**args)
    new(**args).call
  end

  def initialize(message:, bot_ids:)
    @message = message.dup
    @bot_ids = bot_ids
  end

  def call
    return unless for_bot?

    message.gsub!(SLACK_TAG_REGEX, '').strip!

    parse_commands || parse_sounds
  end

  private

  attr_reader :message

  def for_bot?
    @bot_ids.any? { |id| message.include?("<@#{id}>") }
  end

  def parse_commands
    return { command: 'silence' } if message == 'silence'
  end

  def parse_sounds
    sound, effects_string = message.split(/[^\S]+/, 2)

    {
      sound:    to_uri(sound),
      effects:  parse_effects(effects_string)
    }
  end

  def to_uri(sound)
    return sound if sound.match?(URI_REGEX)
    return sound[1..-2] if sound.match?(SLACK_URI_REGEX)

    sound += MP3 unless sound.ends_with?(MP3)

    GetDropboxLink.call(sound).tap do |url|
      raise SoundNotFoundError.new(sound) unless url
    end
  end

  def parse_effects(effects_string)
    return [] unless effects_string

    effects_string.scan(EFFECTS_REGEX).map do |effect, args|
      effect_name = effect.camelize
      effect_hash = parse_effect_args(args)

      { name: effect_name, args: effect_hash }
    end
  end

  def parse_effect_args(args)
    args.to_s.scan(EFFECT_REGEX).each_with_object({}) do |(k, v), obj|
      obj[k.to_sym] = cast_to_js_type(v)
    end
  end

  def cast_to_js_type(object)
    object =~ NUMBER_REGEX ? object.to_f : object.to_s
  end
end
