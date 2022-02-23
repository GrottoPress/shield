struct Users::BearerLogins::IndexPage < MainLayout
  needs bearer_logins : Array(BearerLogin)
  needs user : User
  needs pages : Lucky::Paginator

  def content
    text "Users::BearerLogins::IndexPage"
  end
end
