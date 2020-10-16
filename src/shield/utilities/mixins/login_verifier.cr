module Shield::LoginVerifier
  macro included
    include Shield::Verifier

    def verify : Login?
      return hash unless login.try &.status.started?
      expire && return hash if expired?
      login if verify?
    end

    def verify? : Bool?
      return unless login && login_token
      CryptoHelper.verify_sha256?(login_token!, login!.token_digest)
    end

    # To mitigate timing attacks
    private def hash : Nil
      login_token.try { |token| CryptoHelper.hash_sha256(token) }
    end

    private def expire
      LogUserOut.update!(login!, status: Login::Status.new(:expired))
    rescue
      true
    end

    def expired? : Bool?
      login.try { |login| LoginHelper.login_expired?(login) }
    end

    def login! : Login
      login.not_nil!
    end

    @[Memoize]
    def login : Login?
      login_id.try { |id| LoginQuery.new.id(id).first? }
    end

    def login_id! : Int64
      login_id.not_nil!
    end

    def login_token! : String
      login_token.not_nil!
    end
  end
end
