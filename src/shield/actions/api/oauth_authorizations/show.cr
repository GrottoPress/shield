module Shield::Api::OauthAuthorizations::Show
  macro included
    skip :require_logged_out

    # get "/oauth/authorizations/:oauth_authorization_id" do
    #   html ShowPage, oauth_authorization: oauth_authorization
    # end

    getter oauth_authorization : OauthAuthorization do
      OauthAuthorizationQuery.find(oauth_authorization_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == oauth_authorization.user_id
    end
  end
end
