struct PasswordResets::NewPage < MainLayout
  needs operation : StartPasswordReset

  def content
    text "PasswordResets::NewPage"
  end
end
