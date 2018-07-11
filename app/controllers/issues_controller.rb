class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :update, :destroy]

  # GET /issues
  def index
    @issues = Issue.all
    json_response(@issues)
  end

  # POST /issues
  def create
    @issue = Client.first.issues.create!(issue_params) #TODO: delete Client!!!!!!!!!!!!!!!!!
    json_response(@issue, :created)
  end

  # GET /issues/:id
  def show
    json_response(@issue)
  end

  # PUT /issues/:id
  def update
    @issue.update(issue_params)
    head :no_content
  end

  # DELETE /issues/:id
  def destroy
    @issue.destroy
    head :no_content
  end

  private

  def issue_params
    # whitelist params
    params.permit(:title, :body)
  end

  def set_issue
    @issue = Issue.find(params[:id])
  end
end
