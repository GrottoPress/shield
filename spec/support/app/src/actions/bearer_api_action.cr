abstract class BearerApiAction < Lucky::Action
  include Shield::Action
  include Shield::BearerAuthenticationAction

  accepted_formats [:json]

  skip :pin_login_to_ip_address

  def do_require_logged_in_failed
    json({logged_in: false})
  end

  def do_require_logged_out_failed
    json({logged_in: true})
  end

  def do_check_authorization_failed
    json({authorized: false})
  end

  def authorize?(user : User) : Bool
    user.level.admin?
  end
end
