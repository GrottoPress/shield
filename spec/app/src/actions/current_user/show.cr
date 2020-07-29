class CurrentUser::Show < ApiAction
  include Shield::CurrentUser::Show

  get "/profile" do
    authorize(:read, user)
    json({user: user.id})
  end
end
