module Shield::OauthClientParams
  macro included
    include Shield::OauthClientVerifier

    def initialize(@client_secret : String?, @client_id : String?)
    end

    def oauth_client_id?
      credentials?.try(&.id)
    end

    def oauth_client_secret? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : OauthClientCredentials? do
      OauthClientCredentials.from_params?(@client_secret, @client_id)
    end
  end
end
