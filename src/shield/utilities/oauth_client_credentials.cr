module Shield::OauthClientCredentials
  macro included
    include Shield::BasicCredentials
    include Shield::ParamCredentials

    def initialize(@password : String, @id : OauthClient::PrimaryKeyType)
    end

    def self.new(
      operation : Shield::CreateOauthClient,
      oauth_client : Shield::OauthClient
    )
      new(operation.secret, oauth_client.id)
    end

    def oauth_client : OauthClient
      oauth_client?.not_nil!
    end

    getter? oauth_client : OauthClient? do
      OauthClientQuery.new.id(id).first?
    end

    def self.from_params?(params : Avram::Paramable) : self?
      # DISABLED
    end

    def self.from_params?(client_secret : String?, client_id : String?) : self?
      client_secret.try do |client_secret|
        client_id.try do |client_id|
          OauthClient::PrimaryKeyType.adapter.parse(client_id).value.try do |id|
            new(client_secret, id)
          end
        end
      end
    end
  end
end
