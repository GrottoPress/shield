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

    def verify?(code_verifier : String) : Bool
      return false unless method_valid?
      return code_verifier == code_challenge if method_plain?

      digest = Base64.urlsafe_encode Digest::SHA256.digest(code_verifier), false
      Crypto::Subtle.constant_time_compare(digest, code_challenge)
    end
  end
end
