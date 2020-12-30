module Shield::PasswordResetUrl
  macro included
    include Shield::VerificationUrl

    def initialize(token : String)
      @route = PasswordResets::Show.with(token: token)
    end
  end
end
