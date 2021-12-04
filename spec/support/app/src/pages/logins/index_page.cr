struct Logins::IndexPage < MainLayout
  needs logins : Array(Login)
  needs pages : Lucky::Paginator

  def content
    text "Logins::IndexPage"
  end
end
