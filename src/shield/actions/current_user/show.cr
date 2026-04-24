module Shield::CurrentUser::Show
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == self.user.id
    end

    # get "/account" do
    #   html ShowPage, user: user
    # end

    def user
      current_user
    end
  end
end
