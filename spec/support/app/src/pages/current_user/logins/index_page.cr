struct CurrentUser::Logins::IndexPage < MainLayout
  needs logins : Array(Login)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::Logins::IndexPage"
  end
end
