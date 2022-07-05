struct BearerLogins::Token::ShowPage < MainLayout
  needs bearer_login : BearerLogin?
  needs token : String?

  def content
    text "BearerLogins::Token::ShowPage:#{token}"
  end
end
