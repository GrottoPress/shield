class CurrentUser::Show < ApiAction
  include Shield::CurrentUser::Show

  get "/profile" do
    authorize(:read, user) do
      json({user: user.id})
    end
  end
end
