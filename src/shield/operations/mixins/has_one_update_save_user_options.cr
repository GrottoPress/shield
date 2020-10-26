module Shield::HasOneUpdateSaveUserOptions
  macro included
    has_one_update save_user_options : SaveUserOptions, assoc_name: :options
  end
end
