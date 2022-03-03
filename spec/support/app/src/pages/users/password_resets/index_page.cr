struct Users::PasswordResets::IndexPage < MainLayout
  needs password_resets : Array(PasswordReset)
  needs user : User
  needs pages : Lucky::Paginator

  def content
    text "Users::PasswordResets::IndexPage"
  end
end
