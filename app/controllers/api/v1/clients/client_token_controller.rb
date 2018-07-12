module Api
  module V1
    module Clients
      class ClientTokenController < Knock::AuthTokenController
        skip_before_action :verify_authenticity_token, raise: false
      end
    end
  end
end
