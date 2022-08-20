module Shield::Api::BearerLoginHelpers
  macro included
    include Shield::Api::LoginHelpers

    def bearer_logged_in? : Bool
      !bearer_logged_out?
    end

    def bearer_logged_out? : Bool
      current_bearer?.nil?
    end

    def current_user_or_bearer : User
      current_user_or_bearer?.not_nil!
    end

    def current_user_or_bearer? : User?
      current_user? || current_bearer?
    end

    def current_bearer : User
      current_bearer?.not_nil!
    end

    getter? current_bearer : User? do
      current_bearer_login?.try &.user
    end

    def current_bearer_login
      current_bearer_login?.not_nil!
    end

    getter? current_bearer_login : BearerLogin? do
      BearerLoginHeaders.new(request).verify
    end
  end
end
