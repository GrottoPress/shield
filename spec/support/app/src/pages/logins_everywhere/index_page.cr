struct LoginsEverywhere::IndexPage < MainLayout
  needs logins : Array(Login)
  needs pages : Lucky::Paginator

  def content
    text "LoginsEverywhere::IndexPage"
  end
end
