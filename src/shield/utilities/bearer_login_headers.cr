module Shield::BearerLoginHeaders
  macro included
    include Shield::BearerLoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def bearer_login_id?
      credentials?.try(&.id)
    end

    def bearer_login_token? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : BearerLoginCredentials? do
      BearerLoginCredentials.from_headers?(@headers)
    end
  end
end
