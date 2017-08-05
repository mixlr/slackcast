require 'rails_helper'

RSpec.describe SlashCommandsController, type: :controller do
  describe 'POST #create' do
    let(:params) { { text: 'play test.mp3' } }

    subject(:post_create) { post :create, params: params }

    it { is_expected.to have_http_status(:ok) }

    describe 'ReceiveSlashCommand integration' do
      let(:receiver) { ->(params) { 'Hello world' } }

      before { stub_const('ReceiveSlashCommand', receiver) }

      it 'calls the receiver' do
        expect(receiver).to receive(:call).with(hash_including(**params)).once
        post_create
      end

      it 'responds with the receiver return value' do
        post_create
        expect(response.body).to eq 'Hello world'
      end
    end
  end
end
