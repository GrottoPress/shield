struct CurrentLogin::NewPage < MainLayout
  needs operation : StartCurrentLogin

  def content
    text "CurrentLogin::NewPage"
  end
end
