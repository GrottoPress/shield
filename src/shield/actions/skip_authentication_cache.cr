module Shield::SkipAuthenticationCache
  macro included
    def current_user : User?
      current_user__uncached
    end

    def current_login : Login?
      current_login__uncached
    end
  end
end
