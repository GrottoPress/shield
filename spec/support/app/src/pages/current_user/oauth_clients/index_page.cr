struct CurrentUser::OauthClients::IndexPage < MainLayout
  needs oauth_clients : Array(OauthClient)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::OauthClients::IndexPage"
  end
end
