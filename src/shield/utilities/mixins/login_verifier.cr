module Shield::LoginVerifier
  macro included
    include Shield::Verifier

    def verify : Login?
      login? if verify?
    end

    def verify? : Bool?
      return unless login_id? && login_token?
      sha256 = Sha256Hash.new(login_token)

      if login?.try(&.status.active?)
        sha256.verify?(login.token_digest)
      else
        sha256.fake_verify
      end
    end

    def login
      login?.not_nil!
    end

    getter? login : Login? do
      login_id?.try { |id| LoginQuery.new.id(id).preload_user.first? }
    end

    def login_id
      login_id?.not_nil!
    end

    def login_token : String
      login_token?.not_nil!
    end
  end
end
