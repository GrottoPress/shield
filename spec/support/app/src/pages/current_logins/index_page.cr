struct CurrentLogins::IndexPage < MainLayout
  needs logins : Array(Login)
  needs pages : Lucky::Paginator

  def content
    text "CurrentLogins::IndexPage"
  end
end
