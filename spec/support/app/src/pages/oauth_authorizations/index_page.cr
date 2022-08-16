struct OauthAuthorizations::IndexPage < MainLayout
  needs oauth_authorizations : Array(OauthAuthorization)
  needs pages : Lucky::Paginator

  def content
    text "OauthAuthorizations::IndexPage"
  end
end
