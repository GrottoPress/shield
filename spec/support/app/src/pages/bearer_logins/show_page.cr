struct BearerLogins::ShowPage < MainLayout
  needs bearer_login : BearerLogin
  needs operation : CreateBearerLogin

  def content
    text "BearerLogins::ShowPage"
  end
end
