module Shield::LoginSession
  macro included
    include Shield::Session
    include Shield::LoginVerifier

    def login_id? : Int64?
      @session.get?(:login_id).try &.to_i64?
    end

    def login_token? : String?
      @session.get?(:login_token)
    end

    def delete(login : Shield::Login) : self
      delete if login.id == login_id?
      self
    end

    def delete : self
      @session.delete(:login_id)
      @session.delete(:login_token)
      self
    end

    def set(operation : Shield::StartLogin, login : Shield::Login) : self
      set(operation.token, login.id)
    end

    def set(token : String) : self
      BearerToken.from_token?(token).try do |bearer_token|
        set(bearer_token.password, bearer_token.id)
      end

      self
    end

    def set(token : String, id : Number) : self
      @session.set(:login_id, id.to_s)
      @session.set(:login_token, token)
      self
    end
  end
end
