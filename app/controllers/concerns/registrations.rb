module Registrations
  extend ActiveSupport::Concern

  def create
    if klass.new(permitted_params).save
      json_response({ message: I18n.t('registrations.create.success') }, :created)
    else
      json_response({ message: I18n.t('registrations.create.error') }, :unprocessable_entity)
    end
  end

  private

  def permitted_params
    params.permit(:email, :password)
  end

  def klass
    self.class.name.split('::').third.singularize.constantize
  end
end
