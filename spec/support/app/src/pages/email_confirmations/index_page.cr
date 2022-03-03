struct EmailConfirmations::IndexPage < MainLayout
  needs email_confirmations : Array(EmailConfirmation)
  needs pages : Lucky::Paginator

  def content
    text "EmailConfirmations::IndexPage"
  end
end
