abstract struct MainLayout
  include Lucky::HTMLPage

  def render
    content
  end
end
