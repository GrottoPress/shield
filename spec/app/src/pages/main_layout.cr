abstract class MainLayout
  include Lucky::HTMLPage

  abstract def content

  def page_title
    "Shield"
  end

  def render
    html_doctype

    html lang: "en" do
      head do
        title page_title
      end

      body do
        content
      end
    end
  end
end
