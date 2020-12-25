class Users::IndexPage < MainLayout
  needs users : Array(User)
  needs pages : Lucky::Paginator

  def content
    text "Users::IndexPage"
  end
end
