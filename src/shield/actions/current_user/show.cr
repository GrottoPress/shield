module Shield::CurrentUser::Show
  macro included
    skip :require_logged_out

    # get "/account" do
    #   html ShowPage, user: user
    # end

    def user
      current_user!
    end

    def authorize? : Bool
      true
    end
  end
end
