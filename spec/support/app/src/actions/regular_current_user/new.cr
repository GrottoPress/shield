class RegularCurrentUser::New < BrowserAction
  include Shield::CurrentUser::New

  get "/register" do
    operation = RegisterRegularCurrentUser.new
    html NewPage, operation: operation
  end
end
