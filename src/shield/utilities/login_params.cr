module Shield::LoginParams
  macro included
    include Shield::LoginVerifier

    def initialize(@params : Avram::Paramable)
    end

    def login_id?
      credentials?.try(&.id)
    end

    def login_token? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : LoginCredentials? do
      LoginCredentials.from_params?(@params)
    end
  end
end
