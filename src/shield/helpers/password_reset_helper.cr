module Shield::PasswordResetHelper
  macro extended
    extend self

    def password_reset_url(
      operation : StartPasswordReset,
      password_reset : PasswordReset
    ) : String
      password_reset_url(password_reset.id, operation.token)
    end

    def password_reset_url(id, token : String) : String
      PasswordResets::Show.url(id: id.to_i64, token: token)
    end

    def password_reset_expired?(password_reset : PasswordReset) : Bool
      (Time.utc - password_reset.started_at) >
        Shield.settings.password_reset_expiry
    end
  end
end
