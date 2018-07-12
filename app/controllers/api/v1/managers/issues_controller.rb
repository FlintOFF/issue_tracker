module Api
  module V1
    module Managers
      class IssuesController < Api::V1::Managers::BaseController
        before_action :check_assigning, only: %i[update unassign]
        has_scope :by_status, only: :index

        def index
          json_response(apply_scopes(Issue)
                          .order(id: :desc)
                          .paginate(page: page, per_page: per_page))
        end

        def show
          json_response(Issue.find(params[:id]))
        end

        def assign
          if issue.manager
            assigned_error
          else
            issue.update(manager: current_manager)
            json_response({ message: t(:success) }, :ok)
          end
        end

        def unassign
          if issue.status == 'pending'
            issue.update(manager: nil)
            json_response({ message: t(:success) }, :ok)
          else
            json_response({ message: t(:error_not_pending) },
                          :unprocessable_entity)
          end
        end

        def update
          issue.update(issue_params)
          json_response({ message: t(:success) }, :ok)
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
          if issue.manager.nil?
            json_response(
              { message: I18n.t('api.v1.managers.issues.check_assigning.error') },
              :unauthorized
            )
          else
            assigned_error
          end
        end

        def assigned_error
          json_response(
            { message: I18n.t('api.v1.managers.issues.assigned_error.error') },
            :unauthorized
          )
        end
      end
    end
  end
end
