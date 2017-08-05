class ReceiveSlashCommand
  CHANNEL   = 'cast_notifications'.freeze
  S3_URI    = 'https://s3-eu-west-1.amazonaws.com/mixlr-sounds/'.freeze
  URI_REGEX = /\Ahttps?:\/\//.freeze

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @user = params[:user_name]
    @text = params[:text]
  end

  def call
    case text
    when /\Asound\s+([^\s]+)/
      receive_sound($1)
    when /\Areverse_sound\s+([^\s]+)/
      receive_sound($1, reverse: true)
    when /\Adelay_sound\s+([^\s]+)/
      receive_sound($1, delay: true)
    when /\Aimage\s+([^\s]+)/
      receive_image($1)
    else
      receive_unknown
    end
  end

  private
  attr_reader :user, :text

  def receive_sound(sound, reverse: false, delay: false)
    sound = URI.join(S3_URI, sound).to_s unless sound.match?(URI_REGEX)
    base  = File.basename(sound)
    text  = I18n.t(:played_sound, user: user, sound: base)
    emoji = ':speaker:'

    broadcast_command('sound', { url: sound, reverse: reverse, delay: delay })

    '%s %s' % [ emoji, text ]
  end

  def receive_image(image)
    base  = File.basename(image)
    text  = I18n.t(:displayed_image, user: user, image: base)
    emoji = ':camera:'

    broadcast_command('image', { url: image })

    '%s %s' % [ emoji, text ]
  end

  def receive_unknown
    emoji = ':whale:'
    text  = I18n.t(:did_not_recognize_command)

    '%s %s' % [ emoji, text ]
  end

  def broadcast_command(command, args)
    ActionCable.server.broadcast CHANNEL, {
      command: command,
      args: args
    }
  end
end
