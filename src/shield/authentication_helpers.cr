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
      Login.from_session(session).try do |login|
        login.user if login.status == :active
      end
    end
  end
end
