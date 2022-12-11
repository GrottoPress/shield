module Shield::OauthResponseType
  macro included
    CODE = "code"

    def initialize(@response_type : String?)
    end

    def code? : Bool
      @response_type == CODE
    end

    def valid? : Bool
      code?
    end

    def invalid? : Bool
      !valid?
    end

    def to_s(io : IO)
      io << @response_type
    end

    def to_json(json)
      json.string(to_s)
    end

    def to_param : String
      to_s
    end
  end
end
