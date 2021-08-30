require "../../../spec_helper"

private class SaveEmailConfirmation < EmailConfirmation::SaveOperation
  permit_columns :active_at, :inactive_at, :email, :token_digest, :ip_address

  include Shield::Deactivate
end

describe Shield::Deactivate do
  it "sets inactive time" do
    email_confirmation = EmailConfirmationFactory.create &.inactive_at(nil)

    SaveEmailConfirmation.update(
      email_confirmation
    ) do |operation, updated_email_confirmation|
      operation.saved?.should be_true

      updated_email_confirmation.try &.inactive_at.should be_a(Time)

      updated_email_confirmation.inactive_at
        .try &.should(be_close Time.utc, 2.seconds)
    end
  end

  it "sets given inactive time" do
    inactive_at = 2.days.from_now.at_beginning_of_second
    email_confirmation = EmailConfirmationFactory.create &.inactive_at(nil)

    SaveEmailConfirmation.update(
      email_confirmation,
      params(inactive_at: inactive_at)
    ) do |operation, updated_email_confirmation|
      operation.saved?.should be_true
      updated_email_confirmation.inactive_at.should eq(inactive_at)
    end
  end

  it "ensures inactive time is never earlier than active time" do
    active_at = Time.utc(2020, 2, 15, 10, 20, 30)
    email_confirmation = EmailConfirmationFactory.create &.inactive_at(nil)

    SaveEmailConfirmation.update(
      email_confirmation,
      params(active_at: active_at, inactive_at: active_at - 2.days)
    ) do |operation, updated_email_confirmation|
      operation.saved?.should be_true
      updated_email_confirmation.inactive_at.should be_a(Time)

      updated_email_confirmation.inactive_at
        .try &.should be_close(Time.utc, 2.seconds)
    end
  end
end
