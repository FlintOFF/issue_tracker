class Api::V1::Clients::IssuesController < Api::V1::Clients::BaseController
  has_scope :by_status, only: :index

  def index
    json_response(apply_scopes(current_client.issues)
                    .order(id: :desc)
                    .paginate(page: page, per_page: per_page))
  end

  def create
    json_response(client_issues.create!(issue_params), :created)
  end

  def show
    json_response(issue)
  end

  def update
    issue.update(issue_params)
    json_response({message: 'Updated'}, :ok)
  end

  def destroy
    issue.destroy
    json_response({message: 'Deleted'}, :ok)
  end

  private

  def issue_params
    params.permit(:title, :body)
  end

  def issue
    @issue ||= client_issues.find(params[:id])
  end

  def client_issues
    current_client.issues
  end
end
