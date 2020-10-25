module Shield::PasswordResetHelper
  macro extended
    extend self

    def password_reset_url(
      password_reset : PasswordReset,
      operation : StartPasswordReset
    ) : String
      password_reset_url(token password_reset, operation)
    end

    def password_reset_url(id, token : String) : String
      password_reset_url(token id, token)
    end

    def password_reset_url(token : String) : String
      PasswordResets::Show.url(token: token)
    end

    def token(
      password_reset : PasswordReset,
      operation : StartPasswordReset
    ) : String
      token(password_reset.id, operation.token)
    end

    def token(id, token : String) : String
      LoginHelper.token(id, token)
    end
  end
end
