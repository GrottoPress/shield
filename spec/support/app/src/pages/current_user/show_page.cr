class CurrentUser::ShowPage < MainLayout
  needs user : User

  def content
    text "CurrentUser::ShowPage"
  end
end
