class About::New < ApiAction
  skip :require_authorization

  get "/about/new" do
    json({page: "About::New", session: session.get?(:login_id)})
  end
end
