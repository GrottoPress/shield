module Shield::LoginSession
  macro included
    include Shield::Session
    include Shield::LoginVerifier

    private def expire
      LogUserOut.update!(
        login!,
        status: Login::Status.new(:expired),
        session: @session
      )
    rescue
      true
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

    def set(login : Login, operation : LogUserIn) : self
      set(login.id, operation.token)
    end

    def set(id, token : String) : self
      @session.set(:login_id, id.to_s)
      @session.set(:login_token, token)
      self
    end
  end
end
