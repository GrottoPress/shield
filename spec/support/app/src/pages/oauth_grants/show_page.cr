struct OauthGrants::ShowPage < MainLayout
  needs oauth_grant : OauthGrant

  def content
    text "OauthGrants::ShowPage"
  end
end
