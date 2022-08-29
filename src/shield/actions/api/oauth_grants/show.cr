module Shield::Api::OauthGrants::Show
  macro included
    skip :require_logged_out

    # get "/oauth/grants/:oauth_grant_id" do
    #   html ShowPage, oauth_grant: oauth_grant
    # end

    getter oauth_grant : OauthGrant do
      OauthGrantQuery.find(oauth_grant_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == oauth_grant.user_id
    end
  end
end
