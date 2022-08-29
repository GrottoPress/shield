module Shield::OauthAuthorizationPkce
  macro included
    include Lucille::JSON

    METHOD_PLAIN = "plain"
    METHOD_S256 = "S256"

    getter code_challenge : String = ""
    getter code_challenge_method : String = METHOD_PLAIN

    def method_plain? : Bool
      code_challenge_method == METHOD_PLAIN
    end

    def method_s256? : Bool
      code_challenge_method == METHOD_S256
    end

    def method_valid? : Bool
      method_plain? || method_s256?
    end

    def method_invalid? : Bool
      !method_valid?
    end

    def method_allowed? : Bool
      code_challenge_method.in?(
        Shield.settings.oauth_code_challenge_methods_allowed
      )
    end
  end
end
