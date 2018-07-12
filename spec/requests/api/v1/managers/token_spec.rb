require 'rails_helper'

RSpec.describe 'Tokens API', type: :request do
  let!(:manager) { create(:manager) }
  let(:valid_params) { { 'auth' => { email: manager.email, password: manager.password } } }
  let(:invalid_params) { { 'auth' => { email: Faker::Internet.email, password: 'password' } } }
  let(:base_path) { '/api/v1/managers' }

  describe 'POST /tokens' do
    it 'responds successfully' do
      post "#{base_path}/tokens", params: valid_params
      assert_response :success
    end

    it 'responds unsuccessfully' do
      post "#{base_path}/tokens", params: invalid_params
      assert_response :missing
    end
  end
end