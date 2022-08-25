module Shield::OauthClientUserSettings
  macro included
    getter? oauth_access_token_notify : Bool = true

    def oauth_access_token_notify
      oauth_access_token_notify?
    end
  end
end
