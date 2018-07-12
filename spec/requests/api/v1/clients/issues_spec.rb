require 'rails_helper'

RSpec.describe 'Issues API', type: :request do

  let!(:client_1) { create(:client_with_issues, issues_count: 2) }
  let!(:client_2) { create(:client_with_issues, issues_count: 2) }
  let(:client_1_issue) { client_1.issues.first }
  let(:client_2_issue) { client_2.issues.first }
  let(:headers) { auth_headers(client_1.id) }
  let(:invalid_headers) { { 'Authorization' => nil } }
  let(:base_path) { '/api/v1/clients' }

  # Test suite for GET /issues
  describe 'GET /issues' do
    before { get "#{base_path}/issues", params: {}, headers: headers }

    it 'returns issues' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns right order (most recent at the top)' do
      expect(json.first['id']).to eq(2)
      expect(json.second['id']).to eq(1)
    end

    context 'filter by "status"' do
      before do
        client_1_issue.update(status: :in_progress)
        get "#{base_path}/issues", params: { by_status: :in_progress }, headers: headers
      end

      it 'returns only in_progress issues' do
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
        expect(json.first['status']).to eq('in_progress')
      end
    end

    context 'when unauthorized request' do
      before { get "#{base_path}/issues", params: {}, headers: invalid_headers }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Test suite for GET /issues/:id
  describe 'GET /issues/:id' do
    before { get "#{base_path}/issues/#{client_1_issue.id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the issue' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(client_1_issue.id)
        expect(json['title']).to eq(client_1_issue.title)
        expect(json['body']).to eq(client_1_issue.body)
        expect(json['client_id']).to eq(client_1.id)
        expect(json['status']).to eq(client_1_issue.status)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'should not see issues of another client' do
      before { get "#{base_path}/issues/#{client_2_issue.id}", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Issue/)
      end
    end
  end

  # Test suite for POST /issues
  describe 'POST /issues' do
    let(:valid_attributes) { { title: 'Test issue', body: 'Body of test issue', status: 'in_progress', manager_id: 2 } }

    context 'when the request is valid' do
      before { post "#{base_path}/issues", params: valid_attributes, headers: headers }

      it 'creates a issue' do
        expect(json['title']).to eq('Test issue')
        expect(json['body']).to eq('Body of test issue')
        expect(json['client_id']).to eq(client_1.id)
        expect(json['status']).to eq('pending') # not be able to update the status of your issues
        expect(json['manager_id']).to eq(nil) # not be able to update the assignend manager of your issues
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "#{base_path}/issues", params: { title: 'Foobar' }, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['message']).to match(/Validation failed: Body can't be blank/)
      end
    end
  end

  # Test suite for PUT /issues/:id
  describe 'PUT /issues/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "#{base_path}/issues/#{client_1_issue.id}", params: valid_attributes, headers: headers }

      it 'returns success message' do
        expect(json['message']).to eq('Updated')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'should not update issues of another client' do
      before { put "#{base_path}/issues/#{client_2_issue.id}", params: valid_attributes, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Issue/)
      end
    end
  end

  # Test suite for DELETE /issues/:id
  describe 'DELETE /issues/:id' do
    context 'should delete issues' do
      before { delete "#{base_path}/issues/#{client_1_issue.id}", params: {}, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to eq('Deleted')
      end
    end

    context 'should not delete issues of another client' do
      before { delete "#{base_path}/issues/#{client_2_issue.id}", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Issue/)
      end
    end
  end
end