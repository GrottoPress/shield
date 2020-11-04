class EmailConfirmationCurrentUser::NewPage < MainLayout
  needs operation : RegisterEmailConfirmationCurrentUser

  def content
    text "EmailConfirmationCurrentUser::NewPage"
  end
end
