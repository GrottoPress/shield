module Shield::EmailConfirmationUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @url = Shield.settings.email_confirmation_url.call(token)
    end
  end
end
