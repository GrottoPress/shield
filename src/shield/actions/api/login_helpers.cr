module Shield::Api::LoginHelpers
  macro included
    include Shield::LoginHelpers

    @[Memoize]
    def current_login : Login?
      LoginHeaders.new(request.headers).verify
    end

    def current_or_bearer_user! : User
      current_or_bearer_user.not_nil!
    end

    def current_or_bearer_user : User?
      current_user || current_bearer_user
    end

    def bearer_logged_in? : Bool
      !bearer_logged_out?
    end

    def bearer_logged_out? : Bool
      current_bearer_user.nil?
    end

    def current_bearer_user! : User
      current_bearer_user.not_nil!
    end

    @[Memoize]
    def current_bearer_user : User?
      current_bearer_login.try &.user!
    end

    def current_bearer_login! : BearerLogin
      current_bearer_login.not_nil!
    end

    @[Memoize]
    def current_bearer_login : BearerLogin?
      BearerLoginHeaders.new(request.headers).verify
    end
  end
end
