module Shield::BearerLoginVerifier
  macro included
    include Shield::Verifier

    def verify : BearerLogin?
      bearer_login if verify?
    end

    def verify? : Bool?
      return unless bearer_login_id && bearer_login_token
      sha_256 = Sha256Hash.new(bearer_login_token!)

      if bearer_login.try(&.active?)
        sha_256.verify?(bearer_login!.token_digest)
      else
        sha_256.fake_verify
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
  end
end
