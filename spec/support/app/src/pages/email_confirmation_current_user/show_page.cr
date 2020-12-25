class EmailConfirmationCurrentUser::ShowPage < MainLayout
  needs user : User

  def content
    text "EmailConfirmationCurrentUser::ShowPage"
  end
end
