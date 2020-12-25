class EmailConfirmationCurrentUser::EditPage < MainLayout
  needs operation : UpdateEmailConfirmationCurrentUser

  def content
    text "EmailConfirmationCurrentUser::EditPage"
  end
end
