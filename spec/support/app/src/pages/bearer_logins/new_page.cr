class BearerLogins::NewPage < MainLayout
  needs operation : CreateBearerLogin

  def content
    text "BearerLogins::NewPage"
  end
end
