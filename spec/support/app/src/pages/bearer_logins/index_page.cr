class BearerLogins::IndexPage < MainLayout
  needs bearer_logins : Array(BearerLogin)
  needs pages : Lucky::Paginator

  def content
    text "BearerLogins::IndexPage"
  end
end
