struct CurrentUser::BearerLogins::NewPage < MainLayout
  needs operation : CreateBearerLogin

  def content
    text "CurrentUser::BearerLogins::NewPage"
  end
end
