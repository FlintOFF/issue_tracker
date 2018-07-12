module Registrations
  extend ActiveSupport::Concern

  def create

    if klass.new(permitted_params).save
      json_response( { message: 'Account created successfully' }, :created)
    else
      json_response( { message: "Validation failed: Password can't be blank, Email can't be blank, Password digest can't be blank" }, :unprocessable_entity)
    end
  end

  private

  def permitted_params
    params.permit(:email, :password, :password_confirmation)
  end

  def klass
    self.class.name.split('::').third.singularize.constantize
  end
end