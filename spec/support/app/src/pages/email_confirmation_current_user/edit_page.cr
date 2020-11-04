class EmailConfirmationCurrentUser::EditPage < MainLayout
  needs operation : UpdateConfirmedEmail

  def content
    text "EmailConfirmationCurrentUser::EditPage"
  end
end
