abstract class ApiAction < Lucky::Action
  include Shield::Action

  accepted_formats [:json]

  private def require_logged_in_action
    json({logged_in: false, return_path: Login.return_path(session)})
  end

  private def require_logged_out_action
    json({logged_in: true})
  end
end
