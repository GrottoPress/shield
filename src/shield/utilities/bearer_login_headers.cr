module Shield::BearerLoginHeaders
  macro included
    def initialize(@headers : HTTP::Headers)
    end

    def verify!
      verify.not_nil!
    end

    def verify
      yield self, verify
    end

    def verify : BearerLogin?
      return hash unless bearer_login.try &.status.started?
      expire && return hash if expired?
      bearer_login if verify?
    end

    def verify? : Bool?
      return unless bearer_login && bearer_login_token

      CryptoHelper.verify_sha256?(
        bearer_login_token!,
        bearer_login!.token_digest
      )
    end

    # To mitigate timing attacks
    private def hash : Nil
      bearer_login_token.try { |token| CryptoHelper.hash_sha256(token) }
    end

    private def expire
      RevokeBearerLogin.update!(
        bearer_login!,
        status: BearerLogin::Status.new(:expired)
      )
    rescue
      true
    end

    def expired? : Bool?
      bearer_login.try do |bearer_login|
        BearerLoginHelper.bearer_login_expired?(bearer_login)
      end
    end

    def bearer_login! : BearerLogin
      bearer_login.not_nil!
    end

    @[Memoize]
    def bearer_login : BearerLogin?
      bearer_login_id.try { |id| BearerLoginQuery.new.id(id).first? }
    end

    def bearer_login_id! : Int64
      bearer_login_id.not_nil!
    end

    def bearer_login_token! : String
      bearer_login_token.not_nil!
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
