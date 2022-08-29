module Shield::OauthGrantPkce
  macro included
    METHOD_PLAIN = "plain"
    METHOD_SHA256 = "S256"

    def initialize(@metadata : OauthGrantMetadata)
    end

    def challenge : String
      @metadata.code_challenge.to_s
    end

    def challenge_method : ChallengeMethod
      ChallengeMethod.new(@metadata.code_challenge_method)
    end

    def verify?(verifier : String) : Bool
      return false unless challenge_method.valid?
      return verifier == challenge if challenge_method.plain?

      digest = Base64.urlsafe_encode(Digest::SHA256.digest(verifier), false)
      Crypto::Subtle.constant_time_compare(digest, challenge)
    end

    private struct ChallengeMethod
      def initialize(@method : String)
      end

      def plain? : Bool
        @method == OauthGrantPkce::METHOD_PLAIN
      end

      def sha256? : Bool
        @method == OauthGrantPkce::METHOD_SHA256
      end

      def valid? : Bool
        plain? || sha256?
      end

      def invalid? : Bool
        !valid?
      end

      def allowed? : Bool
        @method.in?(Shield.settings.oauth_code_challenge_methods_allowed)
      end

      def to_s(io)
        io << @method
      end
    end
  end
end
