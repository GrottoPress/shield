class Home::Index < ApiAction
  skip :require_authorization
  skip :require_logged_in

  get "/" do
    json({page: "Home::Index", previous_page: previous_page})
  end
end
