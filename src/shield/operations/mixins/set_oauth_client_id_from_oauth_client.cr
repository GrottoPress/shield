module Shield::SetOauthClientIdFromOauthClient
  macro included
    needs oauth_client : OauthClient?

    before_save do
      set_oauth_client_id
    end

    def oauth_client! : OauthClient?
      oauth_client || oauth_client_id.value.try do |value|
        OauthClientQuery.new.id(value).first?
      end
    end

    private def set_oauth_client_id
      oauth_client.try do |oauth_client|
        oauth_client_id.value = oauth_client.id
      end
    end
  end
end
