abstract class BrowserAction < Lucky::Action
  include Shield::BrowserAction

  include Shield::LoginHelpers
  include Shield::EmailConfirmationHelpers
  include Shield::PasswordResetHelpers

  include Shield::LoginPipes
  include Shield::EmailConfirmationPipes
  include Shield::PasswordResetPipes

  accepted_formats [:html, :json], default: :html

  skip :protect_from_forgery

  authorize do |user|
    user.level.admin?
  end

  def do_require_logged_in_failed
    response.headers["X-Logged-In"] = "false"
    previous_def
  end

  def do_require_logged_out_failed
    response.headers["X-Logged-In"] = "true"
    previous_def
  end

  def do_check_authorization_failed
    response.headers["X-Authorized"] = "false"
    previous_def
  end

  def do_pin_login_to_ip_address_failed
    response.headers["X-IP-Address-Changed"] = "true"
    previous_def
  end

  def do_pin_password_reset_to_ip_address_failed
    response.headers["X-Ip-Address-Changed"] = "true"
    previous_def
  end

  def do_pin_email_confirmation_to_ip_address_failed
    response.headers["X-Ip-Address-Changed"] = "true"
    previous_def
  end

  def do_enforce_login_idle_timeout_failed
    response.headers["X-Login-Timed-Out"] = "true"
    previous_def
  end
end
