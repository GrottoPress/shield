module Shield::LoginSession
  macro included
    include Shield::Session
    include Shield::LoginVerifier

    def login_id : Int64?
      @session.get?(:login_id).try &.to_i64?
    end

    def login_token : String?
      @session.get?(:login_token)
    end

    def delete(login : Login) : self
      delete if login.id == login_id
      self
    end

    def delete : self
      @session.delete(:login_id)
      @session.delete(:login_token)
      self
    end

    def set(operation : LogUserIn, login : Login) : self
      set(operation.token, login.id)
    end

    def set(token : String) : self
      bearer_token = BearerToken.new(token)
      set(bearer_token.token, bearer_token.id)
    end

    def set(token : String, id) : self
      @session.set(:login_id, id.to_s)
      @session.set(:login_token, token)
      self
    end
  end
end
