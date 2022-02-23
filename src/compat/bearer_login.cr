module Shield::LoginHelpers
  macro included
    @[Deprecated("Use `#current_user_or_bearer` instead")]
    def current_or_bearer_user : User
      current_user_or_bearer
    end

    @[Deprecated("Use `#current_user_or_bearer?` instead")]
    def current_or_bearer_user? : User?
      current_user_or_bearer?
    end

    @[Deprecated("Use `#current_bearer` instead")]
    def current_bearer_user : User
      current_bearer
    end

    @[Deprecated("Use `#current_bearer?` instead")]
    def current_bearer_user? : User?
      current_bearer?
    end
  end
end
