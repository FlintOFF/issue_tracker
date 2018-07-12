module Api
  module V1
    module Managers
      class BaseController < Api::V1::BaseController
        before_action :authenticate_manager
      end
    end
  end
end
