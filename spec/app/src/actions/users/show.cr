class Users::Show < ApiAction
  include Shield::Users::Show

  # skip :require_logged_in

  get "/users/:user_id" do
    # authorize(:read, user)
    json({user: user.id})
  end
end
