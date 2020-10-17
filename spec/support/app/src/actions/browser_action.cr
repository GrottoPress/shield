abstract class BrowserAction < Lucky::Action
  include Shield::BrowserAction

  accepted_formats [:json]

  skip :protect_from_forgery

  def do_require_logged_in_failed
    json({
      logged_in: false,
      return_url: ReturnUrlSession.new(session).return_url
    })
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

  def authorize?(user : User) : Bool
    user.level.admin?
  end
end
