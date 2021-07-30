module Shield::BearerLoginHeaders
  macro included
    include Shield::BearerLoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def bearer_login_id : Int64?
      token_from_headers.try &.id
    end

    def bearer_login_token : String?
      token_from_headers.try &.token
    end

    private getter token_from_headers : BearerToken? do
      BearerToken.from_headers(@headers)
    end
  end
end
