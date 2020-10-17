module Shield::EmailConfirmationParams
  macro included
    include Shield::EmailConfirmationVerifier

    def initialize(@params : Avram::Paramable)
    end

    def email_confirmation_user_id : Int64?
      token_from_params.try(&.[0]?).try &.to_i64
    rescue
    end

    def email_confirmation_email : String?
      token_from_params.try &.[1]?
    end

    def email_confirmation_ip_address : String?
      token_from_params.try(&.[2]?).try do |ip|
        Socket::IPAddress.new(ip, 0).address
      end
    rescue
    end

    def email_confirmation_started_at : Time?
      token_from_params.try(&.[3]?).try { |time| Time.unix(time.to_i64) }
    rescue
    end

    @[Memoize]
    private def token_from_params
      @params.get?("token").try do |token|
        CryptoHelper.verify_and_decrypt(token)
      end
    end
  end
end
