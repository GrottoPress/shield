module Shield::Api::SkipAuthenticationCache
  macro included
    include Shield::SkipAuthenticationCache

    def current_login? : Login?
      LoginHeaders.new(request.headers).verify
    end

    def current_bearer_user? : User?
      current_bearer_login?.try &.user!
    end

    def current_bearer_login? : BearerLogin?
      BearerLoginHeaders.new(request.headers).verify
    end
  end
end
