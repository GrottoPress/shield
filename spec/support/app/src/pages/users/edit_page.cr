class Users::EditPage < MainLayout
  needs operation : UpdateUser

  def content
    text "Users::EditPage"
  end
end
