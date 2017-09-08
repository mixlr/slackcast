require 'rails_helper'

RSpec.describe ParseMessage do
  let(:bot_ids) { ['U6WBCEV61'] }
  let(:bot_id) { bot_ids.first }
  let(:sound_url) { 'http://www.dropbox.com/test.mp3' }

  before {
    allow(GetDropboxLink).to receive(:call) { sound_url }
  }

  subject(:result) {
    described_class.call(
      message: message,
      bot_ids: bot_ids
    )
  }

  context 'with a message with no recipients' do
    let(:message) { 'test.mp3' }
    it { is_expected.to be nil }
  end

  context 'with a message with another recipient' do
    let(:message) { '<@U4WBHFI53> test.mp3' }
    it { is_expected.to be nil }
  end

  context 'with a message intended for the bot' do
    let(:message) { "<@#{bot_id}> #{message_body}" }
    let(:message_body) { 'test' }

    it { is_expected.to match(sound: sound_url, effects: []) }

    it 'retrieves the Dropbox link' do
      expect(GetDropboxLink)
        .to receive(:call)
        .once
        .with('test.mp3')
        .and_return(sound_url)

      result
    end

    context 'when the mp3 extension is supplied' do
      let(:message_body) { 'test.mp3' }

      it { is_expected.to eq(sound: sound_url, effects: []) }
    end

    context 'when a URL is supplied in Slack format' do
      let(:message_body) { '<http://www.example.com/test.mp3>' }

      it { is_expected.to eq(sound: 'http://www.example.com/test.mp3', effects: []) }
    end

    context 'when the sound does not exist on Dropbox' do
      before {
        expect(GetDropboxLink)
          .to receive(:call)
          .and_return(nil)
      }

      it 'raises SoundNotFoundError' do
        expect { result }.to raise_error(ParseMessage::SoundNotFoundError)
      end
    end

    context 'with a single effect' do
      context 'with no arguments' do
        let(:message_body) { 'test.mp3 Delay' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: {} } ]
          )
        end
      end

      context 'with a single argument' do
        let(:message_body) { 'test.mp3 Delay(feedback=0.5)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: { feedback: 0.5 } } ]
          )
        end
      end

      context 'with multiple arguments' do
        let(:message_body) { 'test.mp3 Delay(feedback=0.5 wetLevel=2)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: { feedback: 0.5, wetLevel: 2 } } ]
          )
        end
      end

      context 'with multiple arguments separated by commas' do
        let(:message_body) { 'test.mp3 Delay(feedback=0.5,wetLevel=2)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: { feedback: 0.5, wetLevel: 2 } } ]
          )
        end
      end

      context 'with multiple arguments separated by colons' do
        let(:message_body) { 'test.mp3 Delay(feedback: 0.5, wetLevel: 0.6)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: { feedback: 0.5, wetLevel: 0.6 } } ]
          )
        end
      end
    end

    context 'with two effects' do
      context 'with no arguments' do
        let(:message_body) { 'test.mp3 Delay Distortion' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: {} }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'with arguments passed to one effect' do
        let(:message_body) { 'test.mp3 Delay(feedback=3.0) Distortion' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: { feedback: 3.0 } }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'when the effects are in lower-case' do
        let(:message_body) { 'test.mp3 delay(feedback: 1) distortion' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: { feedback: 1 } }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'when the effects are in underscore' do
        let(:message_body) { 'test.mp3 ping_pong_delay(feedback: 0.25) distortion' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'PingPongDelay', args: { feedback: 0.25 } }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'with arguments passed to both effects' do
        let(:message_body) { 'test.mp3 Delay(feedback=3.0 wetLevel=1) Distortion(amount=6)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: sound_url,
            effects: [ { name: 'Delay', args: { feedback: 3.0, wetLevel: 1 } }, { name: 'Distortion', args: { amount: 6 } } ]
          )
        end
      end
    end
  end
end
