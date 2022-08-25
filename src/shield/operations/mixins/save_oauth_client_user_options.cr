module Shield::SaveOauthClientUserOptions
  macro included
    permit_columns :oauth_access_token_notify

    before_save do
      validate_oauth_access_token_notify_required
    end

    private def validate_oauth_access_token_notify_required
      validate_required oauth_access_token_notify,
        message: Rex.t(:"operation.error.oauth_access_token_notify_required")
    end
  end
end
