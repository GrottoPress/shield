class RegularCurrentUser::Edit < BrowserAction
  include Shield::CurrentUser::Edit

  skip :pin_login_to_ip_address

  get "/profile/edit" do
    operation = UpdateRegularCurrentUser.new(user, current_login: current_login)
    html EditPage, operation: operation
  end
end
