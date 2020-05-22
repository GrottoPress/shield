module Shield::DeletePasswordResetToken
  macro included
    before_save do
      delete_token
    end

    private def delete_token
      token_hash.value = nil
    end
  end
end
