struct OauthClients::EditPage < MainLayout
  needs operation : UpdateOauthClient

  def content
    text "OauthClients::EditPage"
  end
end
