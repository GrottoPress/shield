module Shield::BearerLogins::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
    #   html IndexPage, bearer_logins: active_bearer_logins, pages: pages
    # end

    # private def active_bearer_logins
    #   bearer_logins.select &.active?
    # end

    def pages
      paginated_bearer_logins[0]
    end

    @[Memoize]
    def bearer_logins
      paginated_bearer_logins[1].map &.itself
    end

    private def paginated_bearer_logins
      paginate(BearerLoginQuery.new.user_id(user.id))
    end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
