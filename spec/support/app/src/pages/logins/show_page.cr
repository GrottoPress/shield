struct Logins::ShowPage < MainLayout
  needs login : Login

  def content
    text "Logins::ShowPage"
  end
end
