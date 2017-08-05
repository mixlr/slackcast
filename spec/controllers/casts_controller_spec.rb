require 'rails_helper'

RSpec.describe CastsController, type: :controller do
  describe 'GET #show' do
    subject { get :show }

    it { is_expected.to have_http_status(:ok) }
  end
end
