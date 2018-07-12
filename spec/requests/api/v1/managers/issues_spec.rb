require 'rails_helper'

RSpec.describe 'Issues API', type: :request do

  let!(:client) { create(:client_with_issues, issues_count: 10) }
  let!(:manager_1) { create(:manager) }
  let!(:manager_2) { create(:manager) }
  let(:issue) { client.issues.first }
  let(:issue_id) { issue.id }
  let(:missing_issue_id) { 9999 }
  let(:headers) { auth_headers(client.id) }
  let(:invalid_headers) { { 'Authorization' => nil } }
  let(:base_path) { '/api/v1/managers' }

  # Test suite for GET /issues
  describe 'GET /issues' do
    before { get "#{base_path}/issues", params: {}, headers: headers }

    it 'returns issues' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    context 'filter by "status"' do
      before do
        issue.update(status: :in_progress)
        get "#{base_path}/issues", params: { by_status: :in_progress }, headers: headers
      end

      it 'returns only in_progress issues' do
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
        expect(json.first['status']).to eq('in_progress')
      end
    end

    context 'pagination' do
      before do
        c = create(:client_with_issues, issues_count: 30)
        get "#{base_path}/issues", params: { page: 1 }, headers: auth_headers(c.id)
      end

      it 'must return only 25 issues' do
        expect(json).not_to be_empty
        expect(json.size).to eq(25)
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
    before { get "#{base_path}/issues/#{issue_id}", params: {}, headers: headers }

    context 'should have access to all issues (even if not assigned)' do
      it 'returns the issue' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(issue_id)
        expect(json['title']).to eq(issue.title)
        expect(json['body']).to eq(issue.body)
        expect(json['client_id']).to eq(issue.client_id)
        expect(json['status']).to eq(issue.status)
        expect(json['manager_id']).to eq(nil)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record not exists' do
      before { patch "#{base_path}/issues/#{missing_issue_id}/assign", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error message' do
        expect(json['message']).to eq("Couldn't find Issue with 'id'=#{missing_issue_id}")
      end
    end
  end


  describe 'PATCH /issues/:id/assign' do

    context 'when the record is not assigned before' do
      before { patch "#{base_path}/issues/#{issue_id}/assign", params: {}, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to eq('Assigned')
      end
    end

    context 'when the record already assign' do
      before do
        issue.update(manager: manager_1)
        patch "#{base_path}/issues/#{issue_id}/assign", params: {}, headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(json['message']).to eq('Issue is assigned to another manager')
      end
    end

    context 'when the record not exists' do
      before { patch "#{base_path}/issues/#{missing_issue_id}/assign", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error message' do
        expect(json['message']).to eq("Couldn't find Issue with 'id'=#{missing_issue_id}")
      end
    end
  end

  describe 'PATCH /issues/:id/unassign' do

    context 'when the record is assigned before' do
      before do
        issue.update(manager: manager_1)
        patch "#{base_path}/issues/#{issue_id}/unassign", params: {}, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to eq('Unassigned')
      end
    end

    context 'when the issue have status in_progress' do
      before do
        issue.update(manager: manager_1, status: 'in_progress')
        patch "#{base_path}/issues/#{issue_id}/unassign", params: {}, headers: headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns success message' do
        expect(json['message']).to eq("Can't unassign because issue status is not 'pending'")
      end
    end

    context 'when the issue have status resolved' do
      before do
        issue.update(manager: manager_1, status: 'resolved')
        patch "#{base_path}/issues/#{issue_id}/unassign", params: {}, headers: headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns success message' do
        expect(json['message']).to eq("Can't unassign because issue status is not 'pending'")
      end
    end

    context 'when the record is not assigned to any manager' do
      before do
        patch "#{base_path}/issues/#{issue_id}", params: {status: 'in_progress'}, headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(json['message']).to eq('Issue is not assigned to any manager')
      end
    end

    context 'when the record is assigned to another manager' do
      before do
        issue.update(manager: manager_2)
        patch "#{base_path}/issues/#{issue_id}/unassign", params: {}, headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(json['message']).to eq('Issue is assigned to another manager')
      end
    end

    context 'when the record not exists' do
      before { patch "#{base_path}/issues/#{missing_issue_id}/unassign", params: {}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error message' do
        expect(json['message']).to eq("Couldn't find Issue with 'id'=#{missing_issue_id}")
      end
    end
  end

  describe 'PATCH /issues/:id' do

    context 'when the record is assigned before' do
      before do
        issue.update(manager: manager_1)
        patch "#{base_path}/issues/#{issue_id}", params: {status: 'in_progress'}, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns success message' do
        expect(json['message']).to eq('Updated')
      end
    end

    context 'when the record is assigned to another manager' do
      before do
        issue.update(manager: manager_2)
        patch "#{base_path}/issues/#{issue_id}", params: {status: 'in_progress'}, headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(json['message']).to eq('Issue is assigned to another manager')
      end
    end

    context 'when the record is not assigned to any manager' do
      before do
        patch "#{base_path}/issues/#{issue_id}", params: {status: 'in_progress'}, headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns error message' do
        expect(json['message']).to eq('Issue is not assigned to any manager')
      end
    end

    context 'when the record not exists' do
      before { patch "#{base_path}/issues/#{missing_issue_id}", params: {status: 'in_progress'}, headers: headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns error message' do
        expect(json['message']).to eq("Couldn't find Issue with 'id'=#{missing_issue_id}")
      end
    end
  end
end