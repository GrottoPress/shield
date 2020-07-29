module Shield::Login
  macro included
    include Shield::AuthenticationColumns(Login)

    def expired? : Bool
      (Time.utc - started_at) > Shield.settings.login_expiry
    end
  end
end
