require 'rails_helper'

RSpec.describe 'Registration API', type: :request do
  let(:valid_attributes) do
    {
      email: Faker::Internet.email,
      password: 'password'
    }
  end
  let(:base_path) { '/api/v1/clients' }

  describe 'POST /registrations' do
    context 'when valid request' do
      before { post "#{base_path}/registrations", params: valid_attributes }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end
    end

    context 'when invalid request' do
      before { post "#{base_path}/registrations", params: {} }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed/)
      end
    end
  end
end
