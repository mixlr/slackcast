require 'rails_helper'

RSpec.describe '@mick' do
  let(:sound_url) { 'http://www.dropbox.com/test.mp3' }
  let(:message) { "#{SlackRubyBot.config.user} #{sound}" }

  xdescribe '(?<sound>.*)' do
    let(:sound) { "moo" }

    before do
      allow(GetDropboxLink).to receive(:call) { sound_url }
    end

    it 'replies with thumbs up' do
      expect(message: message).to respond_with_slack_message(':thumbs_up:')
    end

    context 'with effects' do
      let(:sound) { "moo ping_pong_delay(delayTimeLeft: 100, delayTimeRight: 1000, feedback: 0.8, wetLevel: 0.8)" }

      it 'replies with thumbs up' do
        expect(message: message)
          .to respond_with_slack_message(":thumbs_up:")
      end
    end

    context 'when he cannot understand the command' do
      it 'replies with thumbs down' do
        expect(message: message)
          .to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
      end
    end
  end

  xdescribe 'random' do
    let(:sound) { 'random' }

    it 'responds with a message' do
      expect(message: message).to respond_with_slack_message(':trollface:')
    end
  end

  xdescribe 'silence' do
    let(:sound) { 'random' }

    it 'responds with a message' do
      expect(Commands::Silence).to receive(:call)
      expect(message: message).to respond_with_slack_message(':mute:')
    end
  end
end
