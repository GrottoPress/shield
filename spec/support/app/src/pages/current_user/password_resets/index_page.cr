struct CurrentUser::PasswordResets::IndexPage < MainLayout
  needs password_resets : Array(PasswordReset)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::PasswordResets::IndexPage"
  end
end
