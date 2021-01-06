module Shield::HasOneSaveUserOptions
  macro included
    has_one save_user_options : SaveUserOptions
  end
end
