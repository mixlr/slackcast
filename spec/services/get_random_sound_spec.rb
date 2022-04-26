require 'rails_helper'

RSpec.describe GetRandomSound do
  let(:sound_url) { 'http://www.dropbox.com/sound.mp3' }
  let(:dropbox_client) { instance_double('Dropbox::Client', list_folder: folder) }
  let(:folder) { [ double(name: 'sound.mp3') ] }

  before do
    allow(service_object)
      .to receive(:client)
      .and_return(dropbox_client)
  end

  subject(:service_object) { GetRandomSound.new }

  it 'selects a random sound' do
    expect(folder).to receive(:sample).once.and_call_original
    service_object.call
  end

  it 'returns the sound URL' do
    expect(service_object.call).to eq "sound"
  end
end
