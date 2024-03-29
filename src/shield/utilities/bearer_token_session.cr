module Shield::BearerTokenSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    def self.new(context : HTTP::Server::Context)
      new(context.session)
    end

    def bearer_token : String
      bearer_token?.not_nil!
    end

    def bearer_token?(*, delete = false) : String?
      @session.get?(:bearer_token).try do |token|
        self.delete if delete
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
      set BearerLoginCredentials.new(operation, bearer_login)
    end

    def set(token : Shield::BearerLoginCredentials) : self
      set(token.to_s)
    end

    def set(token : String) : self
      @session.set(:bearer_token, token)
      self
    end
  end
end
