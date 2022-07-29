module Shield::PasswordResetHelpers
  macro included
    @[Deprecated("Redirect to `PasswordResetCredentials#url` instead")]
    def redirect(to path : Shield::PasswordResetUrl, status : Int32 = 302)
      redirect(path.to_s, status)
    end
  end
end

module Shield::PasswordResetUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @url = Shield.settings.password_reset_url.call(token)
    end
  end
end

struct PasswordResetUrl
  include Shield::PasswordResetUrl
end
