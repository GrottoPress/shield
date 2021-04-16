module Shield::BearerLogins::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
    #   html IndexPage, bearer_logins: bearer_logins, pages: pages
    # end

    def pages
      paginated_bearer_logins[0]
    end

    @[Memoize]
    def bearer_logins : Array(BearerLogin)
      paginated_bearer_logins[1].map &.itself
    end

    @[Memoize]
    private def paginated_bearer_logins : Tuple(
      Lucky::Paginator,
      BearerLoginQuery
    )
      paginate BearerLoginQuery.new.user_id(user.id).is_active
    end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      user.id == self.user.id
    end
  end
end
