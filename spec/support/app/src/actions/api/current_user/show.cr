class Api::CurrentUser::Show < ApiAction
  include Shield::Api::EmailConfirmationCurrentUser::Show

  skip :pin_login_to_ip_address

  get "/ec/profile" do
    json({
      status: "success",
      data: {user: UserSerializer.new(user)}
    })
  end
end
