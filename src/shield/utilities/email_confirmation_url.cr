module Shield::EmailConfirmationUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @route = EmailConfirmations::Show.with(token: token)
    end
  end
end
