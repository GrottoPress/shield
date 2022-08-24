struct CurrentUser::OauthClients::NewPage < MainLayout
  needs operation : RegisterOauthClient

  def content
    text "CurrentUser::OauthClients::NewPage"
  end
end
