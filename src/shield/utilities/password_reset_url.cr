module Shield::PasswordResetUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @url = Shield.settings.password_reset_url.call(token)
    end
  end
end
