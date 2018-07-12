require 'rails_helper'

RSpec.describe 'Registration API', type: :request do

  let!(:manager) { create(:manager) }
  let(:headers) { auth_headers(manager.id) }

  let(:valid_attributes) { {
      email: Faker::Internet.email,
      password: 'password',
      password_confirmation: 'password'
  } }
  let(:base_path) { '/api/v1/managers' }

  # User signup test suite
  describe 'POST /registrations' do
    context 'when valid request' do
      before { post "#{base_path}/registrations", params: valid_attributes, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end
    end

    context 'when invalid request' do
      before { post "#{base_path}/registrations", params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end
  end
end