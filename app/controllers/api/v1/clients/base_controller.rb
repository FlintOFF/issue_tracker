class Api::V1::Clients::BaseController < Api::V1::BaseController
  before_action :authenticate_client
end