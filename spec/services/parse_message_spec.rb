require 'rails_helper'

RSpec.describe ParseMessage do
  let(:bot_ids) { ['U6WBCEV61'] }
  let(:bot_id) { bot_ids.first }

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

    context 'with a simple sound' do
      let(:message_body) { 'test.mp3' }

      it { is_expected.to eq(sound: 'https://s3-eu-west-1.amazonaws.com/mixlr-sounds/test.mp3', effects: []) }
    end

    context 'with a simple sound with no extension' do
      let(:message_body) { 'test' }

      it { is_expected.to match(sound: /test.mp3/, effects: []) }
    end

    context 'with a URL in Slack format' do
      let(:message_body) { '<http://www.example.com/test.mp3>' }

      it { is_expected.to eq(sound: 'http://www.example.com/test.mp3', effects: []) }
    end

    context 'with a single effect' do
      context 'with no arguments' do
        let(:message_body) { 'test.mp3 Delay' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: {} } ]
          )
        end
      end

      context 'with a single argument' do
        let(:message_body) { 'test.mp3 Delay(feedback=0.5)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: { feedback: 0.5 } } ]
          )
        end
      end

      context 'with multiple arguments' do
        let(:message_body) { 'test.mp3 Delay(feedback=0.5 wetLevel=2)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: { feedback: 0.5, wetLevel: 2 } } ]
          )
        end
      end

      context 'with multiple arguments separated by commas' do
        let(:message_body) { 'test.mp3 Delay(feedback=0.5,wetLevel=2)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: { feedback: 0.5, wetLevel: 2 } } ]
          )
        end
      end

      context 'with multiple arguments separated by colons' do
        let(:message_body) { 'test.mp3 Delay(feedback: 0.5, wetLevel: 0.6)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
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
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: {} }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'with arguments passed to one effect' do
        let(:message_body) { 'test.mp3 Delay(feedback=3.0) Distortion' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: { feedback: 3.0 } }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'when the effects are in lower-case' do
        let(:message_body) { 'test.mp3 delay(feedback: 1) distortion' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: { feedback: 1 } }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'when the effects are in underscore' do
        let(:message_body) { 'test.mp3 ping_pong_delay(feedback: 0.25) distortion' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'PingPongDelay', args: { feedback: 0.25 } }, { name: 'Distortion', args: {} } ]
          )
        end
      end

      context 'with arguments passed to both effects' do
        let(:message_body) { 'test.mp3 Delay(feedback=3.0 wetLevel=1) Distortion(amount=6)' }

        it 'parses as expected' do
          expect(result).to match(
            sound: /test.mp3/,
            effects: [ { name: 'Delay', args: { feedback: 3.0, wetLevel: 1 } }, { name: 'Distortion', args: { amount: 6 } } ]
          )
        end
      end
    end
  end
end
