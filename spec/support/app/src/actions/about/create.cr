class About::Create < BrowserAction
  skip :require_logged_in
  skip :require_logged_out

  post "/about" do
    redirect_back fallback: Home::Show
  end
end
