struct BearerLogins::ShowPage < MainLayout
  needs bearer_login : BearerLogin

  def content
    text "BearerLogins::ShowPage"
  end
end
