require 'rails_helper'

RSpec.describe GetCodeVersion do
  subject(:code_version) { described_class.call }

  context 'on Heroku' do
    before { ENV['HEROKU_RELEASE_VERSION'] = 'v1' }

    it { is_expected.to eq 'v1' }
  end

  context 'not on Heroku' do
    it { is_expected.to be_an_instance_of(String) }

    it 'does not change once set' do
      expect(described_class.call).to eq code_version
    end
  end
end
