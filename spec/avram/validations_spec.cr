require "../spec_helper"

describe Avram::Validations do
  describe "#validate_email" do
    it "accepts valid email" do
      email = Avram::Attribute(String?).new(
        :email,
        param: nil,
        value: "uSer@domain.tLD",
        param_key: "user"
      )

      Avram::Validations.validate_email email

      email.valid?.should be_true
    end

    it "rejects invalid email" do
      email = Avram::Attribute(String?).new(
        :email,
        param: nil,
        value: "user",
        param_key: "user"
      )

      Avram::Validations.validate_email email

      email.valid?.should be_false
    end
  end

  describe "#validate_name" do
    it "accepts valid name" do
      name = Avram::Attribute(String?).new(
        :name,
        param: nil,
        value: "john smith-jnr",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_true
    end

    it "rejects number in name" do
      name = Avram::Attribute(String?).new(
        :name,
        param: nil,
        value: "mary42",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_false
    end

    it "rejects leading hyphen in name" do
      name = Avram::Attribute(String?).new(
        :name,
        param: nil,
        value: "-mary",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_false
    end

    it "rejects leading space in name" do
      name = Avram::Attribute(String?).new(
        :name,
        param: nil,
        value: " mary",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_false
    end

    it "rejects special chars in name" do
      name = Avram::Attribute(String?).new(
        :name,
        param: nil,
        value: "mary!jay",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_false
    end
  end

  describe "#validate_username" do
    it "accepts valid username" do
      username = Avram::Attribute(String?).new(
        :username,
        param: nil,
        value: "mary_smith10",
        param_key: "user"
      )

      Avram::Validations.validate_username username

      username.valid?.should be_true
    end

    it "rejects leading number in username" do
      username = Avram::Attribute(String?).new(
        :name,
        param: nil,
        value: "42mary",
        param_key: "user"
      )

      Avram::Validations.validate_username username

      username.valid?.should be_false
    end

    it "rejects special chars in username" do
      username = Avram::Attribute(String?).new(
        :name,
        param: nil,
        value: "mary-jay",
        param_key: "user"
      )

      Avram::Validations.validate_username username

      username.valid?.should be_false
    end
  end

  describe "#validate_ip" do
    it "accepts valid IPv4" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "1.2.3.4",
        param_key: "login"
      )

      Avram::Validations.validate_ip ip

      ip.valid?.should be_true
    end

    it "accepts valid IPv6" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "2a01:4f8:c0c:cfbf::1",
        param_key: "login"
      )

      Avram::Validations.validate_ip ip

      ip.valid?.should be_true
    end

    it "rejects invalid IP" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "shatawale",
        param_key: "login"
      )

      Avram::Validations.validate_ip ip

      ip.valid?.should be_false
    end
  end

  describe "#validate_ip4" do
    it "accepts valid IPv4" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "1.2.3.4",
        param_key: "login"
      )

      Avram::Validations.validate_ip4 ip

      ip.valid?.should be_true
    end

    it "rejects valid IPv6" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "2a01:4f8:c0c:cfbf::1",
        param_key: "login"
      )

      Avram::Validations.validate_ip4 ip

      ip.valid?.should be_false
    end

    it "rejects invalid IP" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "shatawale",
        param_key: "login"
      )

      Avram::Validations.validate_ip4 ip

      ip.valid?.should be_false
    end
  end

  describe "#validate_ip6" do
    it "accepts valid IPv6" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "2a01:4f8:c0c:cfbf::1",
        param_key: "login"
      )

      Avram::Validations.validate_ip6 ip

      ip.valid?.should be_true
    end

    it "rejects valid IPv4" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "1.2.3.4",
        param_key: "login"
      )

      Avram::Validations.validate_ip6 ip

      ip.valid?.should be_false
    end

    it "rejects invalid IP" do
      ip = Avram::Attribute(String?).new(
        :ip,
        param: nil,
        value: "shatawale",
        param_key: "login"
      )

      Avram::Validations.validate_ip6 ip

      ip.valid?.should be_false
    end
  end

  describe "#validate_domain" do
    it "accepts valid domain" do
      domain = Avram::Attribute(String?).new(
        :domain,
        param: nil,
        value: "sarkodie.com",
        param_key: "site"
      )

      Avram::Validations.validate_domain domain

      domain.valid?.should be_true
    end

    it "rejects invalid domain" do
      domain = Avram::Attribute(String?).new(
        :domain,
        param: nil,
        value: "sarkodie.com/wp-admin",
        param_key: "site"
      )

      Avram::Validations.validate_domain domain

      domain.valid?.should be_false
    end
  end

  describe "#validate_url" do
    it "accepts valid URL" do
      url = Avram::Attribute(String?).new(
        :url,
        param: nil,
        value: "sarkodie.com/wp-admin",
        param_key: "site"
      )

      Avram::Validations.validate_url url

      url.valid?.should be_true
    end

    it "rejects valid URL" do
      url = Avram::Attribute(String?).new(
        :url,
        param: nil,
        value: "sarkodie",
        param_key: "site"
      )

      Avram::Validations.validate_url url

      url.valid?.should be_false
    end
  end
end
