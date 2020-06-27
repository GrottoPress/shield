class Logins::NewPage < MainLayout
  # needs operation : Login::SaveOperation?

  def page_title
    "Log in"
  end

  def content
    h1 "Log in"
  end
end
