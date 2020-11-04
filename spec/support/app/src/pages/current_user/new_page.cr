class CurrentUser::NewPage < MainLayout
  needs operation : RegisterCurrentUser

  def content
    text "CurrentUser::NewPage"
  end
end
