module Shield::OauthAuthorizationVerifier
  macro included
    include Shield::Verifier

    def verify!(
      oauth_client : OauthClient,
      code_verifier : String? = nil
    )
      verify(oauth_client, code_verifier).not_nil!
    end

    def verify(
      oauth_client : OauthClient,
      code_verifier : String? = nil
    )
      yield self, verify(oauth_client, code_verifier)
    end

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

      if (!code_verifier || verify_pkce?(code_verifier)) &&
        oauth_authorization?.try(&.status.active?) &&
        oauth_authorization.oauth_client_id == oauth_client.id

        sha256.verify?(oauth_authorization.code_digest)
      else
        sha256.fake_verify
      end
    end

    def verify_pkce?(code_verifier : String?) : Bool
      return false unless oauth_authorization?

      oauth_authorization.pkce.try do |pkce|
        return !!code_verifier.try { |verifier| pkce.verify?(verifier) }
      end

      oauth_authorization.oauth_client.confidential?
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
  end
end
