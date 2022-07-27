module Shield::BearerLoginHeaders
  macro included
    include Shield::BearerLoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def bearer_login_id? : Int64?
      bearer_credentials.try(&.id)
    end

    def bearer_login_token? : String?
      bearer_credentials.try(&.password)
    end

    private getter bearer_credentials : BearerCredentials? do
      BearerCredentials.from_headers?(@headers)
    end
  end
end
