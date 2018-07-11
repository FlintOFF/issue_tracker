require 'rails_helper'

RSpec.describe 'Issues API', type: :request do

  let!(:client) { create(:client_with_issues, issues_count: 10) }
  let(:issue_id) { client.issues.first.id }

  # Test suite for GET /issues
  describe 'GET /issues' do
    before { get '/issues' }

    it 'returns issues' do

      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /issues/:id
  describe 'GET /issues/:id' do
    before { get "/issues/#{issue_id}" }

    context 'when the record exists' do
      it 'returns the issue' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(issue_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:issue_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Issue/)
      end
    end
  end

  # Test suite for POST /issues
  describe 'POST /issues' do
    # valid payload
    let(:valid_attributes) { { title: 'Test issue', body: 'Body of test issue' } }

    context 'when the request is valid' do
      before { post '/issues', params: valid_attributes }

      it 'creates a issue' do
        expect(json['title']).to eq('Test issue')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/issues', params: { title: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Body can't be blank/)
      end
    end
  end

  # Test suite for PUT /issues/:id
  describe 'PUT /issues/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/issues/#{issue_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /issues/:id
  describe 'DELETE /issues/:id' do
    before { delete "/issues/#{issue_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end