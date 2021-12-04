struct CurrentUser::EditPage < MainLayout
  needs operation : UpdateCurrentUser

  def content
    text "CurrentUser::EditPage"
  end
end
