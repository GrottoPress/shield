module Shield::UserNestedSaveOperations
  macro included
    has_one save_user_options : SaveUserOptions, assoc_name: :options
  end
end
