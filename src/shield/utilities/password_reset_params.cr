module Shield::PasswordResetParams
  macro included
    include Shield::PasswordResetVerifier

    def initialize(@params : Avram::Paramable)
    end

    def password_reset_id?
      credentials?.try(&.id)
    end

    def password_reset_token? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : PasswordResetCredentials? do
      PasswordResetCredentials.from_params?(@params)
    end
  end
end
