module Shield::AuthenticationHelpers
  macro included
    private def logged_in? : Bool
      !logged_out?
    end

    private def logged_out? : Bool
      current_user.nil?
    end

    private def current_user! : User
      current_user.not_nil!
    end

    @[Memoize]
    private def current_user : User?
      current_login.try &.user!
    end

    private def current_login! : Login
      current_login.not_nil!
    end

    @[Memoize]
    private def current_login : Login?
      Login.from_session(session)
    end
  end
end
