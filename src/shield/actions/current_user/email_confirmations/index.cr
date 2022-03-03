module Shield::CurrentUser::EmailConfirmations::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/email-confirmations" do
    #   html IndexPage, email_confirmations: email_confirmations, pages: pages
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
        .user_id(user.id)
        .is_active
        .active_at.desc_order
    end

    def user
      current_user
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
