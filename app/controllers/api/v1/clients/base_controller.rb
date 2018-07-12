module Api
  module V1
    module Clients
      class BaseController < Api::V1::BaseController
        before_action :authenticate_client
      end
    end
  end
end
