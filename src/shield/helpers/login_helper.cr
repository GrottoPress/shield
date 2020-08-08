module Shield::LoginHelper
  macro extended
    extend self

    def login_expired?(login : Login) : Bool
      (Time.utc - login.started_at) > Shield.settings.login_expiry
    end
  end
end
