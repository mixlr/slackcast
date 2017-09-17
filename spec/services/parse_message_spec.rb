require 'rails_helper'

RSpec.describe ParseMessage do
  let(:bot_ids) { ['U6WBCEV61'] }
  let(:bot_id) { bot_ids.first }

  let(:message) { "<@#{bot_id}> #{message_body}" }

  subject { described_class.call(message: message) }

  context 'with a simple command' do
    let(:message_body) { 'silence' }

    it { is_expected.to eq([ Commands::Silence, [] ]) }
  end

  context 'with a command with arguments' do
    let(:message_body) { 'random delay' }

    it { is_expected.to eq([ Commands::Random, ['delay']]) }
  end

  context 'with the default service' do
    context 'with a simple sound' do
      let(:message_body) { 'foo' }

      it { is_expected.to eq([ Commands::PlaySound, ['foo'] ]) }
    end

    context 'with a sound with arguments' do
      let(:message_body) { 'foo delay(x: 1)' }

      it { is_expected.to eq([ Commands::PlaySound, ['foo delay(x: 1)'] ]) }
    end

    context 'with the service explicitly provided' do
      context 'with a simple sound' do
        let(:message_body) { 'play_sound foo' }

        it { is_expected.to eq([ Commands::PlaySound, ['foo'] ]) }
      end

      context 'with a sound with arguments' do
        let(:message_body) { 'play_sound foo delay(x: 1)' }

        it { is_expected.to eq([ Commands::PlaySound, ['foo delay(x: 1)'] ]) }
      end
    end
  end
end
