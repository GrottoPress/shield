struct CurrentUser::OauthGrants::IndexPage < MainLayout
  needs oauth_grants : Array(OauthGrant)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::OauthGrants::IndexPage"
  end
end
