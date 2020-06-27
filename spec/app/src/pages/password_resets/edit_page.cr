class PasswordResets::EditPage < MainLayout
  # needs operation : User::SaveOperation?

  def page_title
    "Reset your password"
  end

  def content
    h1 "Reset your password"
  end
end
