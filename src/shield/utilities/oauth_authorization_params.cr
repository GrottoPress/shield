module Shield::OauthAuthorizationParams
  macro included
    include Shield::OauthAuthorizationVerifier

    def initialize(@code : String?)
    end

    def oauth_authorization_id?
      credentials?.try(&.id)
    end

    def oauth_authorization_code? : String?
      credentials?.try(&.password)
    end

    private getter? credentials : OauthAuthorizationCredentials? do
      OauthAuthorizationCredentials.from_params?(@code)
    end
  end
end
