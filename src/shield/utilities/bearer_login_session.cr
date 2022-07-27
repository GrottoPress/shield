module Shield::BearerLoginSession
  macro included
    include Shield::Session

    def bearer_token : String
      bearer_token?.not_nil!
    end

    def bearer_token? : String?
      @session.get?(:bearer_token).try do |token|
        delete
        token
      end
    end

    def delete : self
      @session.delete(:bearer_token)
      self
    end

    def set(
      operation : Shield::CreateBearerLogin,
      bearer_login : Shield::BearerLogin
    ) : self
      set BearerCredentials.new(operation, bearer_login)
    end

    def set(token : Shield::BearerCredentials) : self
      set(token.to_s)
    end

    def set(token : String) : self
      @session.set(:bearer_token, token)
      self
    end
  end
end
