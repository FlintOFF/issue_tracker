module Api
  module V1
    module Managers
      class ManagerTokenController < Knock::AuthTokenController
        skip_before_action :verify_authenticity_token, raise: false
      end
    end
  end
end
