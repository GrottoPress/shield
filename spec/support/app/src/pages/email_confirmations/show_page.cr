struct EmailConfirmations::ShowPage < MainLayout
  needs email_confirmation : EmailConfirmation

  def content
    text "EmailConfirmations::ShowPage"
  end
end
