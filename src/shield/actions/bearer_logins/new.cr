module Shield::BearerLogins::New
  macro included
    skip :require_logged_out

    # get "/bearer-logins/new" do
    #   html NewPage
    # end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
