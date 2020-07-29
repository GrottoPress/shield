module Shield::CurrentUser::Show
  macro included
    # get "/profile" do
    #   authorize(:read, user)
    #   html ShowPage, user: user
    # end

    private def user
      current_user!
    end
  end
end
