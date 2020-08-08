class Home::New < ApiAction
  skip :require_logged_in
  skip :require_logged_out

  post "/new" do
    json({page: "Home::New", previous_page: previous_page_url})
  end
end
