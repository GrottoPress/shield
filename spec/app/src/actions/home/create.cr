class Home::Create < ApiAction
  skip :require_logged_in
  skip :require_logged_out

  post "/" do
    json({page: "Home::Create", previous_page: previous_page_path})
  end
end
