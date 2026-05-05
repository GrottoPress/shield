class Home::Update < BrowserAction
  skip :check_authorization
  skip :require_logged_in
  skip :require_logged_out

  patch "/" do
    redirect_back fallback: Home::Show
  end
end
