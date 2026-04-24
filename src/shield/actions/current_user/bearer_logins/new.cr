module Shield::CurrentUser::BearerLogins::New
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == self.user.id
    end

    # get "/account/bearer-logins/new" do
    #   operation = CreateBearerLogin.new(user: user)
    #   html NewPage, operation: operation
    # end

    def user
      current_user
    end
  end
end
