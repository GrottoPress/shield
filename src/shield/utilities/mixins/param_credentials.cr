module Shield::ParamCredentials
  macro included
    include Shield::Credentials

    def to_param : String
      to_s
    end

    def self.from_params(params : Avram::Paramable) : self
      from_params?(params).not_nil!
    end

    def self.from_params?(params : Avram::Paramable) : self?
      params.get?("token").try { |token| from_token?(token) }
    end
  end
end
