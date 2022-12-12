module Shield::SkipAuthenticationCache
  macro included
    def current_user? : User?
      current_login?.try &.user
    end

    def current_login? : Login?
      LoginSession.new(session).verify
    end
  end
end
