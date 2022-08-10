struct Users::OauthClients::IndexPage < MainLayout
  needs oauth_clients : Array(OauthClient)
  needs user : User
  needs pages : Lucky::Paginator

  def content
    text "Users::OauthClients::IndexPage"
  end
end
