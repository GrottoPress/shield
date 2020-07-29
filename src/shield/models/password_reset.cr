module Shield::PasswordReset
  macro included
    include Shield::AuthenticationColumns(PasswordReset)

    def url(token : String) : String
      PasswordResets::Show.url(id: id, token: token)
    end

    def expired? : Bool
      (Time.utc - started_at) > Shield.settings.password_reset_expiry
    end
  end
end
