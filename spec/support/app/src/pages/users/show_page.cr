struct Users::ShowPage < MainLayout
  needs user : User

  def content
    text "Users::ShowPage"
  end
end
