module Shield::LoginHelper
  macro extended
    extend self

    def login_expired?(login : Login) : Bool
      (Time.utc - login.started_at) > Shield.settings.login_expiry
    end

    def expire_login!(login : Login) : Login
      DeactivateLogin.update!(login, status: Login::Status.new(:expired))
    end
  end
end
