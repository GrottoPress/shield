module Shield::DeleteEmailConfirmation
  macro included
    @email_confirmation : EmailConfirmation? = nil

    param_key :email_confirmation

    attribute email_confirmation_id : Int64

    def submit
      validate_required email_confirmation_id
      validate_email_confirmation_exists

      yield self, delete_email_confirmation
    end

    private def validate_email_confirmation_exists
      email_confirmation_id.value.try do |value|
        @email_confirmation = EmailConfirmationQuery.new.id(value).first?

        unless @email_confirmation
          email_confirmation_id.add_error("does not exist")
        end
      end
    end

    private def delete_email_confirmation
      return unless valid?

      @email_confirmation.try do |email_confirmation|
        email_confirmation if email_confirmation.delete.rows_affected > 0
      end
    end
  end
end
