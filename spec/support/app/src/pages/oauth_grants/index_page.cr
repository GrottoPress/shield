struct OauthGrants::IndexPage < MainLayout
  needs oauth_grants : Array(OauthGrant)
  needs pages : Lucky::Paginator

  def content
    text "OauthGrants::IndexPage"
  end
end
