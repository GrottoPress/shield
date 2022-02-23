struct CurrentUser::BearerLogins::NewPage < MainLayout
  needs operation : CreateCurrentUserBearerLogin

  def content
    text "CurrentUser::BearerLogins::NewPage"
  end
end
