module Shield::CurrentUser::Edit
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == self.user.id
    end

    # get "/account/edit" do
    #   operation = UpdateCurrentUser.new(user, current_login: current_login?)
    #   html EditPage, operation: operation
    # end

    def user
      current_user
    end
  end
end
