class About::New < BrowserAction
  get "/about/new" do
    json({page: "About::New", session: LoginSession.new(session).login_id?})
  end
end
