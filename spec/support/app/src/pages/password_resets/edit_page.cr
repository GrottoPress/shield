struct PasswordResets::EditPage < MainLayout
  needs operation : ResetPassword

  def content
    text "PasswordResets::EditPage"
  end
end
