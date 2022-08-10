struct OauthClients::ShowPage < MainLayout
  needs oauth_client : OauthClient

  def content
    text "OauthClients::ShowPage"
  end
end
