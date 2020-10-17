module Shield::LoginHelper
  macro extended
    extend self

    def login_expired?(login : Login) : Bool
      (Time.utc - login.started_at) > Shield.settings.login_expiry
    end

    def token(login : Login, operation : LogUserIn) : String
      token(login.id, operation.token)
    end

    def token(id, token : String) : String
      "#{id}.#{token}"
    end

    def bearer_header(
      login : Login,
      operation : LogUserIn
    ) : String
      bearer_header(login.id, operation.token)
    end

    def bearer_header(id, token : String)
      "Bearer #{token(id, token)}"
    end

    def token_from_headers(request : HTTP::Request)
      token_from_headers(request.headers)
    end

    # Expects "Authorization" header of format:
    # "Authorization: Bearer <ID>.<TOKEN>",
    # where <ID> = login id, <TOKEN> = login token
    def token_from_headers(headers : HTTP::Headers) : String?
      header = headers["Authorization"]?.try &.split
      return unless header.try(&.size) == 2 && header.try(&.[0]?) == "Bearer"
      header.try &.[1]?
    end
  end
end
