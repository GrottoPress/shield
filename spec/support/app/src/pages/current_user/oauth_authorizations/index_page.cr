struct CurrentUser::OauthAuthorizations::IndexPage < MainLayout
  needs oauth_authorizations : Array(OauthAuthorization)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::OauthAuthorizations::IndexPage"
  end
end
