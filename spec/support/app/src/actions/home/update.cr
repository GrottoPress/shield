class Home::Update < BrowserAction
  skip :require_logged_in
  skip :require_logged_out

  patch "/" do
    redirect_back fallback: Home::Show
  end
end
