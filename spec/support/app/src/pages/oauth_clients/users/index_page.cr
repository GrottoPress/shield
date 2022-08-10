struct OauthClients::Users::IndexPage < MainLayout
  needs users : Array(User)
  needs oauth_client : OauthClient
  needs pages : Lucky::Paginator

  def content
    text "OauthClients::Users::IndexPage"
  end
end
