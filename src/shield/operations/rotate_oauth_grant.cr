module Shield::RotateOauthGrant
  macro included
    getter credentials : OauthGrantCredentials?

    include Shield::EndOauthGrantGracefully

    before_save do
      validate_record_active
    end

    after_save start_oauth_grant

    private def validate_record_active
      record.try do |oauth_grant|
        return if oauth_grant.status.active?
        inactive_at.add_error Rex.t(:"operation.error.oauth_grant_inactive")
      end
    end

    private def start_oauth_grant(oauth_grant : OauthGrant)
      oauth_grant = OauthGrantQuery.preload_user(oauth_grant)
      oauth_grant = OauthGrantQuery.preload_oauth_client(oauth_grant)

      operation = StartOauthGrant.new(
        granted: true,
        type: OauthGrantType.new(OauthGrantType::REFRESH_TOKEN),
        scopes: oauth_grant.scopes,
        oauth_client: oauth_grant.oauth_client,
        user: oauth_grant.user
      )

      @credentials = OauthGrantCredentials.new(operation, operation.save!)
    end
  end
end
