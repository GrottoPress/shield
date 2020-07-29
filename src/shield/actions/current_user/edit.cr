module Shield::CurrentUser::Edit
  macro included
    # get "/profile/edit" do
    #   authorize(:update, user)
    #   html EditPage, user: user
    # end

    private def user
      current_user!
    end
  end
end
