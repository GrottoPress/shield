class Users::Update < BrowserAction
  skip :require_logged_in
  skip :require_logged_out

  patch "/users/:user_id" do
    json({user: 1})
  end
end
