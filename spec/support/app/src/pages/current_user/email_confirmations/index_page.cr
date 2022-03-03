struct CurrentUser::EmailConfirmations::IndexPage < MainLayout
  needs email_confirmations : Array(EmailConfirmation)
  needs pages : Lucky::Paginator

  def content
    text "CurrentUser::EmailConfirmations::IndexPage"
  end
end
