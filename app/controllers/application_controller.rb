class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  after_action :verify_authorized, unless: :clearance_controller?

  private

  def clearance_controller?
    [
      Clearance::PasswordsController,
      Clearance::SessionsController,
      Clearance::UsersController
    ].include?(self.class)
  end
end
