require 'rails_helper'

RSpec.describe 'Tokens API', type: :request do
  let!(:manager) { create(:manager) }
  let(:valid_params) do
    { 'auth' => { email: manager.email, password: manager.password } }
  end
  let(:invalid_params) do
    { 'auth' => { email: Faker::Internet.email, password: 'password' } }
  end
  let(:base_path) { '/api/v1/managers' }

  describe 'POST /tokens' do
    it 'responds successfully' do
      post "#{base_path}/tokens", params: valid_params
      assert_response :success
      expect(json.key?('jwt')).to be true
    end

    it 'responds unsuccessfully' do
      post "#{base_path}/tokens", params: invalid_params
      assert_response :unauthorized
      expect(json['message']).to eq('Invalid email address/password')
    end
  end
end
