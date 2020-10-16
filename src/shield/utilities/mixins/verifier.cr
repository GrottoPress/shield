module Shield::Verifier
  macro included
    def verify!
      verify.not_nil!
    end

    def verify
      yield self, verify
    end
  end
end
