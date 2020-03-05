require 'rails_helper'

RSpec.describe GetDropboxLink do
  let(:basename) { 'test.mp3' }
  let(:public_url) { 'https://www.dropbox.com/test.mp3' }

  let(:dropbox_client) {
    double('Dropbox::Client',
      get_temporary_link: [nil, public_url]
    )
  }

  let(:response) { double('response').as_null_object }

  before {
    allow(Dropbox::Client).to receive(:new).and_return(dropbox_client)
  }

  subject(:service_object) { described_class.new(basename) }

  it 'returns the Dropbox URL' do
    expect(service_object.call).to eq public_url
  end

  context 'when the file does not exist' do
    before {
      expect(dropbox_client)
        .to receive(:get_temporary_link)
        .with(an_instance_of(String))
        .and_raise(Dropbox::ApiError, response)
    }

    it 'returns nil' do
      expect(service_object.call).to be nil
    end
  end
end
