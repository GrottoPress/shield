class Home::New < ApiAction
  skip :require_authorization
  skip :require_logged_in

  post "/new" do
    json({page: "Home::New", previous_page: previous_page})
  end
end
