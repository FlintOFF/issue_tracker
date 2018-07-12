class Api::V1::Clients::ClientTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token, raise: false
end
