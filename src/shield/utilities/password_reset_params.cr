module Shield::PasswordResetParams
  macro included
    include Shield::PasswordResetVerifier

    def initialize(@params : Avram::Paramable)
    end

    def password_reset_id : Int64?
      token_from_params.try &.[0]?.try &.to_i64
    rescue
    end

    def password_reset_token : String?
      token_from_params.try &.[1]?
    end

    @[Memoize]
    private def token_from_params
      @params.get?("token").try &.split('.', 2)
    end
  end
end
