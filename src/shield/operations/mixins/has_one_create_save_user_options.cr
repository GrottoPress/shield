module Shield::HasOneCreateSaveUserOptions
  macro included
    has_one_create save_user_options : SaveUserOptions, assoc_name: :options
  end
end
