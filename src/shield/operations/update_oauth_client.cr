module Shield::UpdateOauthClient
  macro included
    permit_columns :name, :redirect_uri

    before_save do
      validate_status_active
    end

    include Shield::ValidateOauthClient

    private def validate_status_active
      record.try do |oauth_client|
        return if oauth_client.status.active?
        name.add_error Rex.t(:"operation.error.oauth_client_inactive")
      end
    end
  end
end
