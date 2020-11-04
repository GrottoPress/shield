class EmailConfirmations::NewPage < MainLayout
  needs operation : StartEmailConfirmation

  def content
    text "EmailConfirmations::NewPage"
  end
end
