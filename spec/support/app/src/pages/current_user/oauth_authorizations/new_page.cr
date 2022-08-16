struct CurrentUser::OauthAuthorizations::NewPage < MainLayout
  needs operation : StartOauthAuthorization

  def content
    text "CurrentUser::OauthAuthorizations::NewPage"
  end
end
