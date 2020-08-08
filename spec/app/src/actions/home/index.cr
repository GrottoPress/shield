class Home::Index < ApiAction
  skip :require_logged_in
  skip :require_logged_out

  get "/" do
    json({page: "Home::Index", previous_page: previous_page_url})
  end
end
