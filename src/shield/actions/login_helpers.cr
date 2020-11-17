module Shield::LoginHelpers
  macro included
    def logged_in? : Bool
      !logged_out?
    end

    def logged_out? : Bool
      current_user.nil?
    end

    def current_user! : User
      current_user.not_nil!
    end

    @[Memoize]
    def current_user : User?
      current_login.try &.user!
    end

    def current_login! : Login
      current_login.not_nil!
    end

    @[Memoize]
    def current_login : Login?
      LoginSession.new(session).verify
    end
  end
end
