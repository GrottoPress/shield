module Shield::Api::BearerLogins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
    #   json({
    #     status: "success",
    #     data: {
    #       bearer_logins: BearerLoginSerializer.for_collection(
    #         active_bearer_logins
    #       )
    #     },
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
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
      current_or_bearer_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_or_bearer_user.try &.id
    end
  end
end
