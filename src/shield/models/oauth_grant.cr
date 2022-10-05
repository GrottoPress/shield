module Shield::OauthGrant
  macro included
    include Shield::BelongsToOauthClient
    include Shield::BelongsToUser # Resource owner
    include Lucille::SuccessStatusColumns

    column code_digest : String
    column metadata : OauthGrantMetadata?, serialize: true
    column scopes : Array(String)
    column type : OauthGrantType

    def pkce : OauthGrantPkce?
      return unless type.authorization_code?
      metadata.try { |meta| OauthGrantPkce.new(meta) if meta.code_challenge }
    end

    def redirect_uri : String?
      return unless type.authorization_code?
      metadata.try(&.redirect_uri)
    end
  end
end
