struct CurrentUser::OauthPermissions::IndexPage < MainLayout
  needs oauth_clients : Array(OauthClient)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::OauthPermissions::IndexPage"
  end
end
