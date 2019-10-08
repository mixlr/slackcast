require 'slack-ruby-bot'
require 'commands/silence'
require 'commands/play_sound'
require 'commands/random'

class Mick < SlackRubyBot::Bot
  command 'random' do |client, data, match|
    Commands::Random.call
  end

  command 'silence' do |client, data, match|
    Commands::Silence.call
  end

  command /(?<sound>\w*)/ do |client, data, match|
    Commands::PlaySound.call(match[:sound])
  end
end
