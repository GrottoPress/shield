module Shield::EmailConfirmationUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @url = EmailConfirmations::Show.with(token: token).url
    end
  end
end
