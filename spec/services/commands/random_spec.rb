require 'rails_helper'

describe Commands::Random do
  let(:sound_url) { 'http://www.dropbox.com/sound.mp3' }
  let(:args) { nil }

  before {
    allow(GetRandomSound)
      .to receive(:call)
      .once
      .and_return(sound_url)
  }

  subject(:service_object) { described_class.new(args) }

  it 'gets a random sound' do
    expect(GetRandomSound).to receive(:call).once
    service_object.call
  end

  it 'responds with a reaction' do
    expect(service_object.call[:reaction]).to eq 'troll'
  end

  context 'with effects' do
    it 'plays the sound as expected' do
      expect(Commands::PlaySound)
        .to receive(:call)
        .once
        .with(sound_url)

      service_object.call
    end
  end

  context 'with effects' do
    let(:args) { 'delay distortion(amount: 2.0)' }

    it 'passes the effects' do
      expect(Commands::PlaySound)
        .to receive(:call)
        .once
        .with("#{sound_url} delay distortion(amount: 2.0)")

      service_object.call
    end
  end
end
