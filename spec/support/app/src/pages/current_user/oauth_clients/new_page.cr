struct CurrentUser::OauthClients::NewPage < MainLayout
  needs operation : CreateOauthClient

  def content
    text "CurrentUser::OauthClients::NewPage"
  end
end
