module Shield::DeleteEmailConfirmation
  macro included
    @email_confirmation : EmailConfirmation? = nil

    param_key :email_confirmation

    attribute id : Int64

    before_run do
      validate_required id
      validate_email_confirmation_exists
    end

    def run
      @email_confirmation.try do |email_confirmation|
        email_confirmation if email_confirmation.delete.rows_affected > 0
      end
    end

    private def validate_email_confirmation_exists
      id.value.try do |value|
        @email_confirmation = EmailConfirmationQuery.new.id(value).first?

        unless @email_confirmation
          id.add_error("does not exist")
        end
      end
    end
  end
end
