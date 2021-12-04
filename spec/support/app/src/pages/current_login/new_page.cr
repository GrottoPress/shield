struct CurrentLogin::NewPage < MainLayout
  needs operation : LogUserIn

  def content
    text "CurrentLogin::NewPage"
  end
end
