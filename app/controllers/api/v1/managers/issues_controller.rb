class Api::V1::Managers::IssuesController < Api::V1::Managers::BaseController
  before_action :check_assigning, only: [:update, :unassign]

  def index
    json_response(Issue.all)
  end

  def show
    json_response(Issue.find(params[:id]))
  end

  def assign
    if issue.manager
      assigned_error
    else
      issue.update(manager: current_manager)
      json_response({message: 'Assigned'}, :ok)
    end
  end

  def unassign
    issue.update(manager: nil)
    json_response({message: 'Unassigned'}, :ok)
  end

  def update
    issue.update(issue_params)
    json_response({message: 'Updated'}, :ok)
  end

  private

  def issue_params
    params.permit(:status)
  end

  def issue
    @issue ||= Issue.find(params[:id])
  end

  def manager_issues
    current_manager.issues
  end

  def check_assigning
    return if issue.manager == current_manager
    assigned_error
  end

  def assigned_error
    json_response({message: 'Issue is assigned to another manager'}, :unauthorized)
  end
end