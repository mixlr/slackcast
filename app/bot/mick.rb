require 'slack-ruby-bot'
require 'commands/silence'
require 'commands/play_sound'
require 'commands/random'

class Mick < SlackRubyBot::Bot
  command 'random', '' do |client, data, match|
    sound = Commands::Random.call
    result = Commands::PlaySound.call(sound)

    client.web_client.reactions_add(
      name: result[:reaction],
      channel: data.channel,
      timestamp: data.ts,
      as_user: true
    )
  end

  command 'silence' do |client, data, match|
    result = Commands::Silence.call

    client.web_client.reactions_add(
      name: result[:reaction],
      channel: data.channel,
      timestamp: data.ts,
      as_user: true
    )
  end

  command 'police', '👮' do |client, data, match|
    sound = %w(fuck_tha_police sound_of_da_police assassin_de_la_police).sample
    result = Commands::PlaySound.call(sound)

    if result[:ephemeral].present?
      client.web_client.chat_postEphemeral(
        channel: data.channel,
        user: data.user,
        as_user: true,
        text: result[:ephemeral]
      )
    end

    if result[:reaction].present?
      client.web_client.reactions_add(
        name: result[:reaction],
        channel: data.channel,
        timestamp: data.ts,
        as_user: true
      )
    end
  end

  command /(?<sound>.*)/ do |client, data, match|
    sound = match[:sound]
    result = Commands::PlaySound.call(sound)

    if result[:ephemeral].present?
      client.web_client.chat_postEphemeral(
        channel: data.channel,
        user: data.user,
        as_user: true,
        text: result[:ephemeral]
      )
    end

    if result[:reaction].present?
      client.web_client.reactions_add(
        name: result[:reaction],
        channel: data.channel,
        timestamp: data.ts,
        as_user: true
      )
    end
  end
end
