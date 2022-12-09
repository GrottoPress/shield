module Shield::OauthClientHeaders
  macro included
    include Shield::OauthClientVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def self.new(context : HTTP::Server::Context)
      new(context.request)
    end

    def self.new(request : HTTP::Request)
      new(request.headers)
    end

    def oauth_client_id?
      credentials?.try(&.id)
    end

    def oauth_client_secret? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : OauthClientCredentials? do
      OauthClientCredentials.from_headers?(@headers)
    end
  end
end
