module Shield::Api::LoginHelpers
  macro included
    include Shield::LoginHelpers

    def current_login
      current_login?.not_nil!
    end

    getter? current_login : Login? do
      LoginHeaders.new(request.headers).verify
    end

    def current_or_bearer_user
      current_or_bearer_user?.not_nil!
    end

    getter? current_or_bearer_user : User? do
      current_user? || current_bearer_user?
    end

    def bearer_logged_in? : Bool
      !bearer_logged_out?
    end

    def bearer_logged_out? : Bool
      current_bearer_user?.nil?
    end

    def current_bearer_user
      current_bearer_user?.not_nil!
    end

    getter? current_bearer_user : User? do
      current_bearer_login?.try &.user
    end

    def current_bearer_login
      current_bearer_login?.not_nil!
    end

    getter? current_bearer_login : BearerLogin? do
      BearerLoginHeaders.new(request.headers).verify
    end
  end
end
