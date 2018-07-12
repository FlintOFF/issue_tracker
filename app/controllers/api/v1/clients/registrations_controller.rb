module Api
  module V1
    module Clients
      class RegistrationsController < Api::V1::BaseController
        include Registrations
      end
    end
  end
end
