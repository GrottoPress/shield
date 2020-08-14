module Shield::LoginSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    def verify!
      verify.not_nil!
    end

    def verify
      yield self, verify
    end

    def verify : Login?
      return hash unless login.try &.status.started?
      expire && return hash if expired?
      login if verify?
    end

    def verify? : Bool?
      return unless login && login_token
      CryptoHelper.verify_sha256?(login_token!, login!.token_hash)
    end

    # To mitigate timing attacks
    private def hash : Nil
      login_token.try { |token| CryptoHelper.hash_sha256(token) }
    end

    private def expire
      LogUserOut.update!(
        login!,
        status: Login::Status.new(:expired),
        session: @session
      )
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

    def login_id : Int64?
      @session.get?(:login_id).try &.to_i64
    rescue
    end

    def login_token : String?
      @session.get?(:login_token)
    end

    def delete : self
      @session.delete(:login_id)
      @session.delete(:login_token)
      self
    end

    def set(id, token : String) : self
      @session.set(:login_id, id.to_s)
      @session.set(:login_token, token)
      self
    end
  end
end
