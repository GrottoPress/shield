abstract struct MainLayout
  include Lucky::HTMLPage

  def render
    current_user? # Just to be sure it compiles
    content
  end
end
