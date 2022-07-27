module Shield::EmailConfirmationParams
  macro included
    include Shield::EmailConfirmationVerifier

    def initialize(@params : Avram::Paramable)
    end

    def email_confirmation_id? : Int64?
      bearer_credentials.try(&.id)
    end

    def email_confirmation_token? : String?
      bearer_credentials.try(&.password)
    end

    private getter bearer_credentials : BearerCredentials? do
      BearerCredentials.from_params?(@params)
    end
  end
end
