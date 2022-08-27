module Shield::OauthGrantType
  macro included
    AUTHORIZATION_CODE = "authorization_code"
    CLIENT_CREDENTIALS = "client_credentials"
    REFRESH_TOKEN = "refresh_token"

    def initialize(@grant_type : String?)
    end

    def authorization_code? : Bool
      @grant_type == AUTHORIZATION_CODE
    end

    def client_credentials? : Bool
      @grant_type == CLIENT_CREDENTIALS
    end

    def refresh_token? : Bool
      @grant_type == REFRESH_TOKEN
    end

    def valid? : Bool
      authorization_code? || client_credentials? || refresh_token?
    end

    def invalid? : Bool
      !valid?
    end

    def to_s(io)
      io << @grant_type
    end

    def to_json(json)
      json.string(to_s)
    end

    def to_param : String
      to_s
    end
  end
end
