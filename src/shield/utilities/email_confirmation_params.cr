module Shield::EmailConfirmationParams
  macro included
    include Shield::EmailConfirmationVerifier

    def initialize(@params : Avram::Paramable)
    end

    def email_confirmation_id : Int64?
      token_from_params.try &.id
    end

    def email_confirmation_token : String?
      token_from_params.try &.token
    end

    @[Memoize]
    private def token_from_params
      BearerToken.from_params(@params)
    end
  end
end
