struct Users::NewPage < MainLayout
  needs operation : RegisterUser

  def content
    text "Users::NewPage"
  end
end
