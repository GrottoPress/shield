module Shield::CurrentUser::Edit
  macro included
    # get "/profile/edit" do
    #   authorize(:update, user) do
    #     html EditPage, user: user
    #   end
    # end

    def user
      current_user!
    end
  end
end
