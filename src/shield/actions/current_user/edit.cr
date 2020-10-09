module Shield::CurrentUser::Edit
  macro included
    skip :require_logged_out

    # get "/account/edit" do
    #   html EditPage, user: user
    # end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      true
    end
  end
end
