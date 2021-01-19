module Shield::Api::SkipAuthenticationCache
  macro included
    include Shield::SkipAuthenticationCache

    def current_bearer_user : User?
      current_bearer_user__uncached
    end

    def current_bearer_login : BearerLogin?
      current_bearer_login__uncached
    end
  end
end
