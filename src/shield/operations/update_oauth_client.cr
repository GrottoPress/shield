module Shield::UpdateOauthClient # OauthClient::SaveOperation
  macro included
    permit_columns :name, :redirect_uris

    before_save do
      validate_status_active
    end

    include Shield::ValidateOauthClient

    private def validate_status_active
      record.try do |oauth_client|
        return if oauth_client.status.active?
        id.add_error Rex.t(:"operation.error.oauth.client_inactive")
      end
    end
  end
end
