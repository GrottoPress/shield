module Shield::HasOneUserOptions
  macro included
    has_one options : UserOptions
  end
end
