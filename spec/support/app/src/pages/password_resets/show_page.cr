struct PasswordResets::ShowPage < MainLayout
  needs password_reset : PasswordReset

  def content
    text "PasswordResets::ShowPage"
  end
end
