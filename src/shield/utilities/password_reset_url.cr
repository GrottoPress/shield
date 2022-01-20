module Shield::PasswordResetUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @url = PasswordResets::Show.with(token: token).url
    end
  end
end
