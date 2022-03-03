struct PasswordResets::IndexPage < MainLayout
  needs password_resets : Array(PasswordReset)
  needs pages : Lucky::Paginator

  def content
    text "PasswordResets::IndexPage"
  end
end
