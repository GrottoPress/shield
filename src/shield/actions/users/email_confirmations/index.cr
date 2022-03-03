module Shield::Users::EmailConfirmations::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users/:user_id/email-confirmations" do
    #   html IndexPage,
    #     email_confirmations: email_confirmations,
    #     user: user,
    #     pages: pages
    # end

    def pages
      paginated_email_confirmations[0]
    end

    getter email_confirmations : Array(EmailConfirmation) do
      paginated_email_confirmations[1].results
    end

    private getter paginated_email_confirmations : Tuple(
      Lucky::Paginator,
      EmailConfirmationQuery
    ) do
      paginate EmailConfirmationQuery.new
        .user_id(user_id)
        .is_active
        .active_at.desc_order
    end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
