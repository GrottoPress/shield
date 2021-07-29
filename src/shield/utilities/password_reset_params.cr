module Shield::PasswordResetParams
  macro included
    include Shield::PasswordResetVerifier

    def initialize(@params : Avram::Paramable)
    end

    def password_reset_id? : Int64?
      token_from_params.try &.id
    end

    def password_reset_token? : String?
      token_from_params.try &.token
    end

    private getter token_from_params : BearerToken? do
      BearerToken.from_params?(@params)
    end
  end
end
