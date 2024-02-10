module Shield::EndOauthGrantGracefully
  macro included
    include Lucille::Deactivate

    private def set_inactive_at
      record.try do |oauth_grant|
        return if oauth_grant.status.inactive? || oauth_grant.status.unactive?

        inactive_at.value = oauth_grant.type.refresh_token? ?
          Time.utc + Shield.settings.oauth_refresh_token_grace :
          Time.utc

        previous_def
      end
    end
  end
end
