module Shield::EmailConfirmationParams
  macro included
    include Shield::EmailConfirmationVerifier

    def initialize(@params : Avram::Paramable)
    end

    def email_confirmation_id : Int64?
      token_from_params.try &.[0]?.try &.to_i64
    rescue
    end

    def email_confirmation_token : String?
      token_from_params.try &.[1]?
    end

    @[Memoize]
    private def token_from_params
      @params.get?("token").try &.split('.', 2)
    end
  end
end
