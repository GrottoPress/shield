class PasswordResets::NewPage < MainLayout
  needs operation : PasswordReset::SaveOperation?

  def page_title
    "Reset your password"
  end

  def content
    h1 "Reset your password"
  end
end
