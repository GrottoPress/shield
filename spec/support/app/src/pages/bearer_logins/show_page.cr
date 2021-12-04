struct BearerLogins::ShowPage < MainLayout
  needs bearer_login : BearerLogin
  needs token : String

  def content
    text "BearerLogins::ShowPage"
  end
end
