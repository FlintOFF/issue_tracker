module Api
  module V1
    module Managers
      class RegistrationsController < Api::V1::Managers::BaseController
        include Registrations
      end
    end
  end
end
