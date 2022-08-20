module Shield::BearerLoginParams
  macro included
    include Shield::BearerLoginVerifier

    def initialize(@params : Avram::Paramable)
    end

    def bearer_login_id?
      credentials?.try(&.id)
    end

    def bearer_login_token? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : BearerLoginCredentials? do
      BearerLoginCredentials.from_params?(@params)
    end
  end
end
