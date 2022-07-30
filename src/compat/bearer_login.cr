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

module Shield::BearerTokenSession
  macro included
    {% puts "Warning: Deprecated `Shield::BearerTokenSession`. \
      Use `Shield::BearerLoginSession` instead" %}

    include Shield::BearerLoginSession
  end
end

struct BearerToken
  include Shield::BearerLoginToken
end

struct BearerTokenSession
  include Shield::BearerLoginSession
end
