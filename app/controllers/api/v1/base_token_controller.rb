module Api
  module V1
    class BaseTokenController < Knock::AuthTokenController
      skip_before_action :verify_authenticity_token, raise: false
      rescue_from Knock.not_found_exception_class_name do
        render json: { message: 'Invalid email address/password' }, status: :unauthorized
      end
    end
  end
end
