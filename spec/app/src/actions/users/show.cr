class Users::Show < ApiAction
  include Shield::Users::Show

  get "/users/:user_id" do
    json({user: user.id})
  end
end
