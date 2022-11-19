module Shield::BearerLoginHeaders
  macro included
    include Shield::BearerLoginVerifier

    def initialize(@headers : HTTP::Headers)
    end

    def self.new(context : HTTP::Server::Context)
      new(context.request)
    end

    def self.new(request : HTTP::Request)
      new(request.headers)
    end

    def bearer_login_id?
      credentials?.try(&.id)
    end

    def bearer_login_token? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : BearerLoginCredentials? do
      BearerLoginCredentials.from_headers?(@headers)
    end
  end
end
