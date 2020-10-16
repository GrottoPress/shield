module Shield::BearerLoginHeaders
  macro included
    include Shield::BearerLoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def bearer_login_id : Int64?
      token_from_headers.try &.[0]?.try &.to_i64
    rescue
    end

    def bearer_login_token : String?
      token_from_headers.try &.[1]?
    end

    @[Memoize]
    private def token_from_headers
      BearerLoginHelper.token_from_headers(@headers).try &.split('.', 2)
    end
  end
end
