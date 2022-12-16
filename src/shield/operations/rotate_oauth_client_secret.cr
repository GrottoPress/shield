module Shield::RotateOauthClientSecret
  macro included
    include Shield::SetSecret

    before_save do
      validate_not_public
      validate_status_active
    end

    private def validate_not_public
      record.try do |oauth_client|
        return unless oauth_client.public?
        secret_digest.add_error Rex.t(:"operation.error.oauth.client_public")
      end
    end

    private def validate_status_active
      record.try do |oauth_client|
        return if oauth_client.status.active?
        id.add_error Rex.t(:"operation.error.oauth.client_inactive")
      end
    end
  end
end
