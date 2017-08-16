require 'rails_helper'

RSpec.describe ReceiveSlashCommand do
  let(:result) { receiver.call }

  subject(:receiver) { ReceiveSlashCommand.new(params) }

  context 'with a sound' do
    let(:params) {
      {
        text: 'sound test.mp3',
        user_name: 'slack user'
      }
    }

    it 'responds with a message' do
      expect(receiver.call).to eq ':speaker: *slack user* is playing _test.mp3_'
    end

    it 'sends a broadcast' do
      expect(ActionCable.server).to receive(:broadcast).once.with(
        'cast_notifications',
        {
          command: 'sound',
          args: { url: 'https://s3-eu-west-1.amazonaws.com/mixlr-sounds/test.mp3', reverse: false, delay: false }
        }
      )
      receiver.call
    end
  end

  context 'with a reverse sound' do
    let(:params) {
      {
        text: 'reverse_sound test.mp3',
        user_name: 'slack user'
      }
    }

    it 'responds with a message' do
      expect(receiver.call).to eq ':speaker: *slack user* is playing _test.mp3_'
    end

    it 'sends a broadcast' do
      expect(ActionCable.server).to receive(:broadcast).once.with(
        'cast_notifications',
        {
          command: 'sound',
          args: { url: 'https://s3-eu-west-1.amazonaws.com/mixlr-sounds/test.mp3', reverse: true, delay: false }
        }
      )
      receiver.call
    end
  end

  context 'with a sound with delay' do
    let(:params) {
      {
        text: 'delay_sound test.mp3',
        user_name: 'slack user'
      }
    }

    it 'responds with a message' do
      expect(receiver.call).to eq ':speaker: *slack user* is playing _test.mp3_'
    end

    it 'sends a broadcast' do
      expect(ActionCable.server).to receive(:broadcast).once.with(
        'cast_notifications',
        {
          command: 'sound',
          args: { url: 'https://s3-eu-west-1.amazonaws.com/mixlr-sounds/test.mp3', reverse: false, delay: true }
        }
      )
      receiver.call
    end
  end

  context 'with a sound sent through a websocket message' do
    let(:params) {
      {
        text: 'websocket_sound test.mp3',
        user_name: 'slack user'
      }
    }

    before { allow(RestClient).to receive(:get) { 'abcde' } }

    it 'responds with a message' do
      expect(receiver.call).to eq ':speaker: *slack user* is playing _test.mp3_'
    end

    it 'sends a broadcast' do
      expect(ActionCable.server).to receive(:broadcast).once.with(
        'cast_notifications',
        {
          command: 'websocket_sound',
          args: { data: an_instance_of(String) }
        }
      )
      receiver.call
    end
  end

  context 'with an image' do
    let(:params) {
      {
        text: 'image http://www.example.com/example.png',
        user_name: 'slack user'
      }
    }

    it 'responds with a message' do
      expect(receiver.call).to eq ':camera: *slack user* is displaying _example.png_'
    end

    it 'sends a broadcast' do
      expect(ActionCable.server).to receive(:broadcast).once.with(
        'cast_notifications',
        {
          command: 'image',
          args: { url: /\Ahttp.*example.png\z/ }
        }
      )
      receiver.call
    end
  end

  context 'with an unknown command' do
    let(:params) {
      {
        text: 'delete something',
        user_name: 'slack user'
      }
    }

    it 'responds with a message' do
      expect(receiver.call).to eq ':whale: Sorry! Did not recognize that command'
    end
  end
end
