struct Users::OauthAuthorizations::IndexPage < MainLayout
  needs oauth_authorizations : Array(OauthAuthorization)
  needs user : User
  needs pages : Lucky::Paginator

  def content
    text "Users::OauthAuthorizations::IndexPage"
  end
end
