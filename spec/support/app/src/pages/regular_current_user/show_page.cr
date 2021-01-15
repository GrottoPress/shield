class RegularCurrentUser::ShowPage < MainLayout
  needs user : User

  def content
    text "RegularCurrentUser::ShowPage"
  end
end
