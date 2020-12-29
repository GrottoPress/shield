module Shield::PasswordResetHelper
  macro extended
    extend self

    def password_reset_url(
      password_reset : PasswordReset,
      operation : StartPasswordReset
    ) : String
      password_reset_url(password_reset.id, operation.token)
    end

    def password_reset_url(id, token : String) : String
      password_reset_url(BearerToken.new token, id)
    end

    def password_reset_url(token : BearerToken) : String
      password_reset_url(token.to_s)
    end

    def password_reset_url(token : String) : String
      PasswordResets::Show.url(token: token)
    end
  end
end
