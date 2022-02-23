struct Users::Logins::IndexPage < MainLayout
  needs logins : Array(Login)
  needs user : User
  needs pages : Lucky::Paginator

  def content
    text "Users::Logins::IndexPage"
  end
end
