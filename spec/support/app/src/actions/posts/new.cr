class Posts::New < BrowserAction
  skip :require_logged_out
  skip :pin_login_to_ip_address

  get "/posts/new" do
    json({action: "Posts::New"})
  end
end
