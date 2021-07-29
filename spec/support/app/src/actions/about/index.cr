class About::Index < BrowserAction
  skip :require_logged_in
  skip :require_logged_out

  get "/about" do
    json({page: "About::Index", previous_page: previous_page_url?})
  end
end
