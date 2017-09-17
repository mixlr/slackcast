require 'rails_helper'

RSpec.describe SendToBrowser do
  let(:command) { 'play_sound' }
  let(:args) { { sound: 'test.mp3' } }

  subject(:service_object) { SendToBrowser.new(command, **args) }

  it 'sends the ActionCable message' do
    expect(ActionCable.server)
      .to receive(:broadcast)
      .with(CastChannel::NAME, args.merge(command: command))
      .once
      .and_call_original

    service_object.call
  end
end
