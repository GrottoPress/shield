module Shield::BearerLogins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
    #   pages, bearer_logins = paginate(
    #     BearerLoginQuery.new
    #       .user_id(user.id)
    #       .status(BearerLogins::Status.new :started)
    #   )
    #
    #   html IndexPage, bearer_logins: bearer_logins, pages: pages
    # end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
