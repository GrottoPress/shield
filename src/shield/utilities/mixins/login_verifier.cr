module Shield::LoginVerifier
  macro included
    include Shield::Verifier

    def verify : Login?
      return hash unless active?
      login if verify?
    end

    def active? : Bool?
      login.try &.active?
    end

    def verify? : Bool?
      return unless login && login_token
      Sha256Hash.new(login_token!).verify?(login!.token_digest)
    end

    # To mitigate timing attacks
    private def hash : Nil
      login_token.try { |token| Sha256Hash.new(token).hash }
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
