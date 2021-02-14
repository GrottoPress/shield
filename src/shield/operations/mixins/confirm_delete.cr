module Shield::ConfirmDelete
  macro included
    attribute confirm_delete : Bool

    before_delete do
      validate_confirmed
    end

    private def validate_confirmed
      confirm_delete.add_error("check has failed") unless confirm_delete.value
    end
  end
end
