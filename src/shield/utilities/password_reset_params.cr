module Shield::PasswordResetParams
  macro included
    include Shield::PasswordResetVerifier

    def initialize(@params : Avram::Paramable)
    end

    def password_reset_id? : Int64?
      bearer_credentials.try(&.id)
    end

    def password_reset_token? : String?
      bearer_credentials.try(&.password)
    end

    private getter bearer_credentials : BearerCredentials? do
      BearerCredentials.from_params?(@params)
    end
  end
end
