struct OauthAuthorizations::ShowPage < MainLayout
  needs oauth_authorization : OauthAuthorization

  def content
    text "OauthAuthorizations::ShowPage"
  end
end
