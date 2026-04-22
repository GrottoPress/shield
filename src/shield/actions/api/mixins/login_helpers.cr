module Shield::Api::LoginHelpers
  macro included
    include Shield::LoginHelpers

    getter? current_login : Login? do
      LoginHeaders.new(context).verify
    end

    def any_logged_in? : Bool
      !all_logged_out?
    end

    def all_logged_out? : Bool
      logged_out? && bearer_logged_out?
    end

    def bearer_logged_in? : Bool
      !bearer_logged_out?
    end

    def bearer_logged_out? : Bool
      current_bearer?.nil?
    end

    def any_current_user : User
      any_current_user?.not_nil!
    end

    def any_current_user? : User?
      current_user? || current_bearer?
    end

    @[Deprecated("Use #any_current_user instead")]
    def current_user_or_bearer : User
      any_current_user
    end

    @[Deprecated("Use #any_current_user? instead")]
    def current_user_or_bearer? : User?
      any_current_user?
    end

    def current_bearer : User
      current_bearer?.not_nil!
    end

    getter? current_bearer : User? do
      current_bearer_login?.try(&.user)
    end

    def current_bearer_login
      current_bearer_login?.not_nil!
    end

    def current_bearer_login?
      nil
    end
  end
end
