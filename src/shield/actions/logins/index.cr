module Shield::Logins::Index
  macro included
    skip :require_logged_out

    # get "/logins" do
    #   pages, logins = paginate(LoginQuery.new.user_id(user.id))
    #   html IndexPage, logins: logins, pages: pages
    # end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
