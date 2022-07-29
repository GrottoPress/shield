module Shield::EmailConfirmationParams
  macro included
    include Shield::EmailConfirmationVerifier

    def initialize(@params : Avram::Paramable)
    end

    def email_confirmation_id?
      credentials?.try(&.id)
    end

    def email_confirmation_token? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : EmailConfirmationCredentials? do
      EmailConfirmationCredentials.from_params?(@params)
    end
  end
end
