module Shield::CurrentUser::Show
  macro included
    # get "/profile" do
    #   authorize(:read, user) do
    #     html ShowPage, user: user
    #   end
    # end

    def user
      current_user!
    end
  end
end
