class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include Knock::Authenticable

  PER_PAGE = 25

  private

  def page
    params[:page]&.to_i || 1
  end

  def per_page
    params[:per_page]&.to_i || PER_PAGE
  end

  protected

  def t(key)
    I18n.t("#{self.class.name.remove('Controller').downcase.gsub('::', '.')}.#{action_name}.#{key}")
  end
end
