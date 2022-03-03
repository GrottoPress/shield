struct Users::EmailConfirmations::IndexPage < MainLayout
  needs email_confirmations : Array(EmailConfirmation)
  needs user : User
  needs pages : Lucky::Paginator

  def content
    text "Users::EmailConfirmations::IndexPage"
  end
end
