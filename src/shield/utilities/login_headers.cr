module Shield::LoginHeaders
  macro included
    include Shield::LoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def login_id? : Int64?
      bearer_credentials.try(&.id)
    end

    def login_token? : String?
      bearer_credentials.try(&.password)
    end

    private getter bearer_credentials : BearerCredentials? do
      BearerCredentials.from_headers?(@headers)
    end
  end
end
