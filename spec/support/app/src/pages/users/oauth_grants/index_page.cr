struct Users::OauthGrants::IndexPage < MainLayout
  needs oauth_grants : Array(OauthGrant)
  needs user : User
  needs pages : Lucky::Paginator

  def content
    text "Users::OauthGrants::IndexPage"
  end
end
