require 'rails_helper'

RSpec.describe 'Tokens API', type: :request do
  let!(:client) { create(:client) }
  let(:valid_params) { { 'auth' => { email: client.email, password: client.password } } }
  let(:invalid_params) { { 'auth' => { email: Faker::Internet.email, password: 'password' } } }
  let(:base_path) { '/api/v1/clients' }

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
