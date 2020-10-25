module Shield::BearerLoginVerifier
  macro included
    include Shield::Verifier

    def verify : BearerLogin?
      return hash unless active?
      bearer_login if verify?
    end

    def active? : Bool?
      bearer_login.try &.active?
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
  end
end
