module Shield::OauthClientSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    getter? oauth_client : OauthClient? do
      oauth_client_id?.try do |id|
        OauthClientQuery.new.id(id).preload_user.first?
      end
    end

    def oauth_client_id
      oauth_client_id?.not_nil!
    end

    def oauth_client_secret : String
      oauth_client_secret?.not_nil!
    end

    def oauth_client_id?
      @session.get?(:oauth_client_id)
    end

    def oauth_client_secret? : String?
      @session.get?(:oauth_client_secret).try do |secret|
        delete
        secret
      end
    end

    def delete : self
      @session.delete(:oauth_client_id)
      @session.delete(:oauth_client_secret)
      self
    end

    def set(
      operation : OauthClient::SaveOperation,
      oauth_client : Shield::OauthClient
    ) : self
      set(operation.secret, oauth_client.id)
    end

    def set(secret : String, id : OauthClient::PrimaryKeyType) : self
      @session.set(:oauth_client_id, id.to_s)
      @session.set(:oauth_client_secret, secret)
      self
    end
  end
end
