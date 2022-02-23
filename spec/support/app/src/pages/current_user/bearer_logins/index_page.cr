struct CurrentUser::BearerLogins::IndexPage < MainLayout
  needs bearer_logins : Array(BearerLogin)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::BearerLogins::IndexPage"
  end
end
