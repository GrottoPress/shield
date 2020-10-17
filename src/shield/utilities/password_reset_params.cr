module Shield::PasswordResetParams
  macro included
    include Shield::PasswordResetVerifier

    def initialize(@params : Avram::Paramable)
    end

    def password_reset_id : Int64?
      @params.get?("id").try &.to_i64
    rescue
    end

    def password_reset_token : String?
      @params.get?("token")
    end
  end
end
