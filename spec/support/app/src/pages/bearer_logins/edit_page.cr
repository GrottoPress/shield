struct BearerLogins::EditPage < MainLayout
  needs operation : UpdateBearerLogin

  def content
    text "BearerLogins::EditPage"
  end
end
