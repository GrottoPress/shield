abstract class ApiAction < Lucky::Action
  include Shield::ApiAction

  include Shield::Api::BearerLoginHelpers
  include Shield::Api::EmailConfirmationHelpers
  include Shield::Api::PasswordResetHelpers

  include Shield::Api::BearerLoginPipes
  include Shield::Api::EmailConfirmationPipes
  include Shield::Api::PasswordResetPipes

  accepted_formats [:html, :json], default: :json

  route_prefix "/api/v0"

  authorize do |user|
    user.level.admin?
  end

  def do_require_logged_in_failed
    json({logged_in: false})
  end

  def do_require_logged_out_failed
    json({logged_in: true})
  end

  def do_check_authorization_failed
    json({authorized: false})
  end

  def do_pin_login_to_ip_address_failed
    json({ip_address_changed: true})
  end

  def do_pin_password_reset_to_ip_address_failed
    json({ip_address_changed: true})
  end

  def do_pin_email_confirmation_to_ip_address_failed
    json({ip_address_changed: true})
  end
end
