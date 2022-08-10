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

module Shield::BearerLoginToken
  macro included
    def bearer_login : BearerLogin
      bearer_login?.not_nil!
    end

    getter? bearer_login : BearerLogin? do
      id?.try { |id| BearerLoginQuery.new.id(id).first? }
    end
  end
end

struct BearerToken
  include Shield::BearerLoginToken
end
