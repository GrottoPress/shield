module Shield::OauthAuthorizationVerifier
  macro included
    include Shield::Verifier

    def verify(
      oauth_client : OauthClient,
      code_verifier : String? = nil
    ) : OauthAuthorization?
      oauth_authorization? if verify?(oauth_client, code_verifier)
    end

    def verify?(
      oauth_client : OauthClient,
      code_verifier : String? = nil
    ) : Bool?
      return unless oauth_authorization_id? && oauth_authorization_code?
      sha256 = Sha256Hash.new(oauth_authorization_code)

      if verify_code_verifier(code_verifier) &&
        oauth_authorization?.try(&.status.active?) &&
        oauth_authorization.oauth_client_id == oauth_client.id

        sha256.verify?(oauth_authorization.code_digest)
      else
        sha256.fake_verify
      end
    end

    def oauth_authorization
      oauth_authorization?.not_nil!
    end

    getter? oauth_authorization : OauthAuthorization? do
      oauth_authorization_id?.try do |id|
        OauthAuthorizationQuery.new
          .id(id)
          .preload_user
          .preload_oauth_client
          .first?
      end
    end

    def oauth_authorization_id
      oauth_authorization_id?.not_nil!
    end

    def oauth_authorization_code : String
      oauth_authorization_code?.not_nil!
    end

    private def verify_code_verifier(code_verifier)
      challenge = oauth_authorization?.try(&.pkce.try &.code_challenge)
      confidential = oauth_authorization?.try(&.oauth_client.confidential?)
      method = oauth_authorization?.try(&.pkce.try &.code_challenge_method)

      return true if !challenge && confidential
      return false unless challenge && code_verifier
      return code_verifier == challenge if method == "plain"

      digest = Base64.urlsafe_encode Digest::SHA256.digest(code_verifier), false
      Crypto::Subtle.constant_time_compare(digest, challenge)
    end
  end
end
