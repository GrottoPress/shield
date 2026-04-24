module Shield::OauthGrants::Show
  macro included
    skip :require_logged_out

    authorize_user do |user|
      super || user.id == oauth_grant.user_id
    end

    # get "/oauth/grants/:oauth_grant_id" do
    #   html ShowPage, oauth_grant: oauth_grant
    # end

    getter oauth_grant : OauthGrant do
      OauthGrantQuery.find(oauth_grant_id)
    end
  end
end
