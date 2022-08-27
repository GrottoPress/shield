module Shield::OauthGrantType
  macro included
    def initialize(@grant_type : String?)
    end

    def authorization_code? : Bool
      @grant_type == "authorization_code"
    end

    def client_credentials? : Bool
      @grant_type == "client_credentials"
    end

    def valid? : Bool
      authorization_code? || client_credentials?
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
