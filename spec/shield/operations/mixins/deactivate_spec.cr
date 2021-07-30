require "../../../spec_helper"

describe Shield::Deactivate do
  it "sets inactive time" do
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    StartEmailConfirmation.create(
      params(email: "uSer@ex4mple.tld"),
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)

      EndEmailConfirmation.update(
        email_confirmation.not_nil!,
        session: nil
      ) do |operation, updated_email_confirmation|
        operation.saved?.should be_true

        updated_email_confirmation.inactive_at.should be_a(Time)
        updated_email_confirmation.inactive_at
          .try &.should(be_close Time.utc, 2.seconds)
      end
    end
  end

  it "sets given inactive time" do
    active_at = Time.utc(2016, 2, 15, 10, 20, 30)
    inactive_at = Time.utc(2020, 2, 15, 10, 20, 30)
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    StartEmailConfirmation.create(
      params(email: "uSer@ex4mple.tld"),
      remote_ip: ip_address,
      active_at: active_at
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)

      EndEmailConfirmation.update(
        email_confirmation.not_nil!,
        session: nil,
        inactive_at: inactive_at
      ) do |operation, updated_email_confirmation|
        operation.saved?.should be_true
        updated_email_confirmation.inactive_at.should eq(inactive_at)
      end
    end
  end

  it "ensures inactive time is never earlier than active time" do
    active_at = Time.utc(2020, 2, 15, 10, 20, 30)
    inactive_at = Time.utc(2016, 2, 15, 10, 20, 30)
    ip_address = Socket::IPAddress.new("1.2.3.4", 5)

    StartEmailConfirmation.create(
      params(email: "uSer@ex4mple.tld"),
      remote_ip: ip_address,
      active_at: active_at
    ) do |operation, email_confirmation|
      email_confirmation.should be_a(EmailConfirmation)

      EndEmailConfirmation.update(
        email_confirmation.not_nil!,
        session: nil,
        inactive_at: inactive_at
      ) do |operation, updated_email_confirmation|
        operation.saved?.should be_true
        updated_email_confirmation.inactive_at.should be_a(Time)

        updated_email_confirmation.inactive_at
          .try &.should be_close(Time.utc, 2.seconds)
      end
    end
  end
end
