class Home::Edit < BrowserAction
  skip :require_logged_in
  skip :require_logged_out

  get "/edit" do
    redirect_back fallback: Home::Index, allow_external: true
  end
end
