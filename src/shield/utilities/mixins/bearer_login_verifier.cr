module Shield::BearerLoginVerifier
  macro included
    include Shield::Verifier

    def verify : BearerLogin?
      bearer_login? if verify?
    end

    def verify? : Bool?
      return unless bearer_login_id? && bearer_login_token?
      sha256 = Sha256Hash.new(bearer_login_token)

      if bearer_login?.try(&.status.active?)
        sha256.verify?(bearer_login.token_digest)
      else
        sha256.fake_verify
      end
    end

    def bearer_login
      bearer_login?.not_nil!
    end

    getter? bearer_login : BearerLogin? do
      bearer_login_id?.try do |id|
        BearerLoginQuery.new.id(id).preload_user.first?
      end
    end

    def bearer_login_id
      bearer_login_id?.not_nil!
    end

    def bearer_login_token : String
      bearer_login_token?.not_nil!
    end
  end
end
