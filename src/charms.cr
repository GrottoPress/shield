module Lucky
  abstract class Action
    include MailHelpers
  end

  class MessageEncryptor
    # Set default digest to `:sha256`
    def initialize(
      @secret : String,
      @cipher_algorithm = "aes-256-cbc",
      @digest = :sha256
    )
      previous_def
    end
  end

  class MessageVerifier
    # Set default digest to `:sha256`
    def initialize(@secret : String, @digest = :sha256)
      previous_def
    end
  end
end

module Avram
  abstract class Operation
    include MailHelpers
  end

  abstract class DeleteOperation(T)
    include MailHelpers
  end

  abstract class SaveOperation(T)
    include MailHelpers

    # Getting rid of default validations in Avram
    #
    # See https://github.com/luckyframework/lucky/discussions/1209#discussioncomment-46030
    #
    # All operations are expected to explicitly define any validations
    # needed
    def valid? : Bool
      # These validations must be ran after all `before_save` callbacks have completed
      # in the case that someone has set a required field in a `before_save`. If we run
      # this in a `before_save` ourselves, the ordering would cause this to be ran first.
      # validate_required *required_attributes
      custom_errors.empty? && attributes.all?(&.valid?)
    end
  end
end
