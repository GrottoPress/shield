class CurrentUser::Show < ApiAction
  include Shield::ShowCurrentUser

  get "/profile" do
    authorize(:read, user)
    json({user: user.id})
  end
end
