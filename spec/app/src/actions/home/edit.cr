class Home::Edit < ApiAction
  skip :require_logged_in
  skip :require_logged_out

  get "/edit" do
    redirect_back fallback: Home::Index, status: :found, allow_external: true
  end
end
