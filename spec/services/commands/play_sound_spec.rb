require 'rails_helper'

RSpec.describe Commands::PlaySound do
  let(:sound_url) { 'http://www.dropbox.com/test.mp3' }

  before {
    allow(GetDropboxLink).to receive(:call) { sound_url }
  }

  subject(:service_object) { described_class.new(message) }

  context 'when no mp3 extension is supplied' do
    let(:message) { 'test' }

    it 'returns nil' do
      expect(service_object.call).to match hash_including(reaction: a_kind_of(String))
    end

    it 'retrieves the Dropbox link' do
      expect(GetDropboxLink)
        .to receive(:call)
        .once
        .with('test.mp3')
        .and_return(sound_url)

      service_object.call
    end

    it 'sends the sound to the browser' do
      expect(SendToBrowser)
        .to receive(:call)
        .once
        .with(:play_sound, sound: sound_url, effects: [])
        .and_call_original

      service_object.call
    end
  end

  context 'when an mp3 extension is supplied' do
    let(:message) { 'test.mp3' }

    it 'returns nil' do
      expect(service_object.call).to match hash_including(reaction: a_kind_of(String))
    end

    it 'retrieves the Dropbox link' do
      expect(GetDropboxLink)
        .to receive(:call)
        .once
        .with('test.mp3')
        .and_return(sound_url)

      service_object.call
    end

    it 'sends the sound to the browser' do
      expect(SendToBrowser)
        .to receive(:call)
        .once
        .with(:play_sound, sound: sound_url, effects: [])
        .and_call_original

      service_object.call
    end
  end

  context 'when a URL is supplied in Slack format' do
    let(:sound_url) { 'http://www.example.com/test.mp3' }
    let(:message) { "<#{sound_url}>" }

    it 'returns nil' do
      expect(service_object.call).to match hash_including(reaction: a_kind_of(String))
    end

    it 'does not retrieve a Dropbox link' do
      expect(GetDropboxLink).not_to receive(:call)

      service_object.call
    end

    it 'sends the sound to the browser' do
      expect(SendToBrowser)
        .to receive(:call)
        .once
        .with(:play_sound, sound: sound_url, effects: [])
        .and_call_original

      service_object.call
    end
  end

  context 'when the sound does not exist on Dropbox' do
    let(:message) { 'nope' }

    before {
      expect(GetDropboxLink)
        .to receive(:call)
        .once
        .and_return(nil)
    }

    it 'returns a reaction' do
      expect(service_object.call[:reaction]).to eq '-1'
    end

    it 'returns an ephemeral message' do
      expect(service_object.call[:ephemeral]).to include('could not be located')
    end

    it 'does not send to the browser' do
      expect(SendToBrowser).not_to receive(:call)

      service_object.call
    end
  end

  describe 'parsing effects' do
    shared_examples 'it parses the effects' do
      it 'sends the effect to the browser' do
        expect(SendToBrowser)
          .to receive(:call)
          .once
          .with(:play_sound, hash_including(effects: expected_effects))
          .and_call_original

        service_object.call
      end
    end

    context 'with a single effect' do
      context 'with no arguments' do
        let(:message) { 'test.mp3 Delay' }
        let(:expected_effects) { [{ name: 'Delay', args: {} }] }

        it_behaves_like 'it parses the effects'
      end

      context 'with a single argument' do
        let(:message) { 'test.mp3 Delay(feedback=0.5)' }
        let(:expected_effects) { [{ name: 'Delay', args: { feedback: 0.5 } }] }

        it_behaves_like 'it parses the effects'
      end

      context 'with multiple arguments' do
        let(:message) { 'test.mp3 Delay(feedback=0.5 wetLevel=2)' }
        let(:expected_effects) { [{ name: 'Delay', args: { feedback: 0.5, wetLevel: 2.0 } }] }

        it_behaves_like 'it parses the effects'
      end

      context 'with multiple arguments separated by commas' do
        let(:message) { 'test.mp3 Delay(feedback=0.5, wetLevel=2)' }
        let(:expected_effects) { [{ name: 'Delay', args: { feedback: 0.5, wetLevel: 2.0 } }] }

        it_behaves_like 'it parses the effects'
      end

      context 'with multiple arguments separated by colons' do
        let(:message) { 'test.mp3 Delay(feedback: 0.5, wetLevel=2)' }
        let(:expected_effects) { [{ name: 'Delay', args: { feedback: 0.5, wetLevel: 2.0 } }] }

        it_behaves_like 'it parses the effects'
      end
    end

    context 'with two effects' do
      context 'with no arguments' do
        let(:message) { 'test.mp3 Delay Distortion' }
        let(:expected_effects) { [{ name: 'Delay', args: {} }, { name: 'Distortion', args: {} }] }

        it_behaves_like 'it parses the effects'
      end

      context 'with arguments passed to one effect' do
        let(:message) { 'test.mp3 Delay(feedback=3.0) Distortion' }
        let(:expected_effects) { [{ name: 'Delay', args: { feedback: 3.0 } }, { name: 'Distortion', args: {} }] }

        it_behaves_like 'it parses the effects'
      end

      context 'when the effects are in lower-case' do
        let(:message) { 'test.mp3 delay(feedback=3.0) distortion' }
        let(:expected_effects) { [{ name: 'Delay', args: { feedback: 3.0 } }, { name: 'Distortion', args: {} }] }

        it_behaves_like 'it parses the effects'
      end

      context 'when the effects are in underscore' do
        let(:message) { 'test.mp3 ping_pong_delay(feedback: 0.25) wah_wah' }
        let(:expected_effects) { [{ name: 'PingPongDelay', args: { feedback: 0.25 } }, { name: 'WahWah', args: {} }] }

        it_behaves_like 'it parses the effects'
      end

      context 'with arguments passed to both effects' do
        let(:message) { 'test.mp3 Delay(feedback=3.0 wetLevel=1) Distortion(amount=6)' }
        let(:expected_effects) { [{ name: 'Delay', args: { feedback: 3.0, wetLevel: 1 } }, { name: 'Distortion', args: { amount: 6 } }] }

        it_behaves_like 'it parses the effects'
      end
    end
  end
end
