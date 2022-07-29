module Shield::LoginHeaders
  macro included
    include Shield::LoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def login_id?
      credentials?.try(&.id)
    end

    def login_token? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : LoginCredentials? do
      LoginCredentials.from_headers?(@headers)
    end
  end
end
