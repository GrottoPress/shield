module Shield::BearerCredentials
  macro included
    include Shield::Credentials

    def authenticate(client : HTTP::Client) : Nil
      client.before_request { |request| authenticate(request) }
    end

    def authenticate(request : HTTP::Request) : Nil
      authenticate(request.headers)
    end

    def authenticate(headers : HTTP::Headers) : Nil
      headers["Authorization"] = "Bearer #{to_s}"
    end

    def self.from_headers(request : HTTP::Request) : self
      from_headers(request.headers)
    end

    def self.from_headers(headers : HTTP::Headers) : self
      from_headers?(headers).not_nil!
    end

    def self.from_headers?(request : HTTP::Request) : self?
      from_headers?(request.headers)
    end

    def self.from_headers?(headers : HTTP::Headers) : self?
      header = headers["Authorization"]?.try &.split
      return unless header.try(&.size) == 2 && header.try(&.[0]?) == "Bearer"
      header.try &.[1]?.try { |token| from_token?(token) }
    end
  end
end
