class CurrentUser::Show < BrowserAction
  include Shield::CurrentUser::Show

  get "/profile" do
    json({user: user.id})
  end
end
