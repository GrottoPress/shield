class Api::RegularCurrentUser::Show < ApiAction
  include Shield::Api::CurrentUser::Show

  skip :pin_login_to_ip_address

  get "/profile" do
    json UserSerializer.new(user: user)
  end
end
