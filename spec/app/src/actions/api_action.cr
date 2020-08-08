abstract class ApiAction < Lucky::Action
  include Shield::Action

  accepted_formats [:json]

  def do_require_logged_in_failed
    json({logged_in: false})
  end

  def do_require_logged_out_failed
    json({logged_in: true})
  end

  def do_check_authorization_failed
    json({authorized: false})
  end

  def authorize? : Bool
    current_user!.level.admin?
  end
end
