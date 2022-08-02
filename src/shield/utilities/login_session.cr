module Shield::LoginSession
  macro included
    include Shield::Session
    include Shield::LoginVerifier

    def login_id?
      @session.get?(:login_id).try do |id|
        Login::PrimaryKeyType.adapter.parse(id).value
      end
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
      LoginCredentials.from_token?(token).try do |credentials|
        set(credentials.password, credentials.id)
      end

      self
    end

    def set(token : String, id) : self
      @session.set(:login_id, id.to_s)
      @session.set(:login_token, token)
      self
    end
  end
end
