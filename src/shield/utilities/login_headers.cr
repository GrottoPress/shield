module Shield::LoginHeaders
  macro included
    include Shield::LoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def login_id : Int64?
      token_from_headers.try &.id
    end

    def login_token : String?
      token_from_headers.try &.token
    end

    @[Memoize]
    private def token_from_headers : BearerToken?
      BearerToken.from_headers(@headers)
    end
  end
end
