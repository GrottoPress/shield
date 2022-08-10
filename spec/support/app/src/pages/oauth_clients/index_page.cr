struct OauthClients::IndexPage < MainLayout
  needs oauth_clients : Array(OauthClient)
  needs pages : Lucky::Paginator

  def content
    text "OauthClients::IndexPage"
  end
end
