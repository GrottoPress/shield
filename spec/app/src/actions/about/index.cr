class About::Index < ApiAction
  skip :require_authorization
  skip :require_logged_in

  get "/about" do
    json({page: "About::Index", previous_page: previous_page})
  end
end
