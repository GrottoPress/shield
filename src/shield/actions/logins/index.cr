module Shield::Logins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/logins" do
    #   html IndexPage, logins: active_logins, pages: pages
    # end

    # private def active_logins
    #   logins.select &.active?
    # end

    def pages
      paginated_logins[0]
    end

    @[Memoize]
    def logins : Array(Login)
      paginated_logins[1].map &.itself
    end

    @[Memoize]
    private def paginated_logins : Tuple(Lucky::Paginator, LoginQuery)
      paginate(LoginQuery.new.user_id(user.id))
    end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
