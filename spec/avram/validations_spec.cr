require "../spec_helper"

describe Avram::Validations do
  describe "#validate_email" do
    it "accepts valid email" do
      emails = {
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "uSer@domain.tLD",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "uSer._@domain.tLD",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "_._@domain.tLD",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "a@domain.tLD",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "_@domain.tLD",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "user21@domain.tLD",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "user.name@domain.tLD",
          param_key: "user"
        )
      }

      emails.each do |email|
        Avram::Validations.validate_email email
        email.valid?.should be_true
      end
    end

    it "rejects invalid email" do
      emails = {
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "user",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "user-@domain.com",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "user.@domain.com",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: ".user@domain.com",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "user..name@domain.com",
          param_key: "user"
        ),
        Avram::Attribute(String).new(
          :email,
          param: nil,
          value: "21user@domain.com",
          param_key: "user"
        )
      }

      emails.each do |email|
        Avram::Validations.validate_email email
        email.valid?.should be_false
      end
    end
  end

  describe "#validate_name" do
    it "accepts valid name" do
      name = Avram::Attribute(String).new(
        :name,
        param: nil,
        value: "john smith-jnr",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_true
    end

    it "rejects number in name" do
      name = Avram::Attribute(String).new(
        :name,
        param: nil,
        value: "mary42",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_false
    end

    it "rejects leading hyphen in name" do
      name = Avram::Attribute(String).new(
        :name,
        param: nil,
        value: "-mary",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_false
    end

    it "rejects leading space in name" do
      name = Avram::Attribute(String).new(
        :name,
        param: nil,
        value: " mary",
        param_key: "user"
      )

      Avram::Validations.validate_name name

      name.valid?.should be_false
    end

    it "rejects special chars in name" do
      name = Avram::Attribute(String).new(
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
      username = Avram::Attribute(String).new(
        :username,
        param: nil,
        value: "mary_smith10",
        param_key: "user"
      )

      Avram::Validations.validate_username username

      username.valid?.should be_true
    end

    it "rejects leading number in username" do
      username = Avram::Attribute(String).new(
        :name,
        param: nil,
        value: "42mary",
        param_key: "user"
      )

      Avram::Validations.validate_username username

      username.valid?.should be_false
    end

    it "rejects special chars in username" do
      username = Avram::Attribute(String).new(
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
      ip = Avram::Attribute(String).new(
        :ip,
        param: nil,
        value: "1.2.3.4",
        param_key: "login"
      )

      Avram::Validations.validate_ip ip

      ip.valid?.should be_true
    end

    it "accepts valid IPv6" do
      ip = Avram::Attribute(String).new(
        :ip,
        param: nil,
        value: "2a01:4f8:c0c:cfbf::1",
        param_key: "login"
      )

      Avram::Validations.validate_ip ip

      ip.valid?.should be_true
    end

    it "rejects invalid IP" do
      ip = Avram::Attribute(String).new(
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
      ip = Avram::Attribute(String).new(
        :ip,
        param: nil,
        value: "1.2.3.4",
        param_key: "login"
      )

      Avram::Validations.validate_ip4 ip

      ip.valid?.should be_true
    end

    it "rejects valid IPv6" do
      ip = Avram::Attribute(String).new(
        :ip,
        param: nil,
        value: "2a01:4f8:c0c:cfbf::1",
        param_key: "login"
      )

      Avram::Validations.validate_ip4 ip

      ip.valid?.should be_false
    end

    it "rejects invalid IP" do
      ip = Avram::Attribute(String).new(
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
      ip = Avram::Attribute(String).new(
        :ip,
        param: nil,
        value: "2a01:4f8:c0c:cfbf::1",
        param_key: "login"
      )

      Avram::Validations.validate_ip6 ip

      ip.valid?.should be_true
    end

    it "rejects valid IPv4" do
      ip = Avram::Attribute(String).new(
        :ip,
        param: nil,
        value: "1.2.3.4",
        param_key: "login"
      )

      Avram::Validations.validate_ip6 ip

      ip.valid?.should be_false
    end

    it "rejects invalid IP" do
      ip = Avram::Attribute(String).new(
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
      domains = {
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "sarkodie.com",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "74-7music.com",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "music747.abcdef",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "awe--some.photography",
          param_key: "site"
        )
      }

      domains.each do |domain|
        Avram::Validations.validate_domain domain
        domain.valid?.should be_true
      end
    end

    it "rejects invalid domain" do
      domains = {
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "sarkodie.com/wp-admin",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "-sarkodie.com",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "sarkodie-.com",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "sarkodie.99com",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :domain,
          param: nil,
          value: "ghana_ndwom.com",
          param_key: "site"
        )
      }

      domains.each do |domain|
        Avram::Validations.validate_domain domain
        domain.valid?.should be_false
      end
    end
  end

  describe "#validate_domain_label" do
    it "accepts valid domain label" do
      labels = {
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "1blog",
          param_key: "app"
        ),
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "roses-are.red",
          param_key: "app"
        ),
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "abc.def--ghi.jkl.5mno",
          param_key: "app"
        )
      }

      labels.each do |label|
        Avram::Validations.validate_domain_label label
        label.valid?.should be_true
      end
    end

    it "rejects invalid domain label" do
      labels = {
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "-blog",
          param_key: "app"
        ),
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "blog-",
          param_key: "app"
        ),
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "blog.",
          param_key: "app"
        ),
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: ".blog",
          param_key: "app"
        ),
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "abc_def.ghi",
          param_key: "app"
        ),
        Avram::Attribute(String).new(
          :label,
          param: nil,
          value: "sub..domain",
          param_key: "app"
        )
      }

      labels.each do |label|
        Avram::Validations.validate_domain_label label
        label.valid?.should be_false
      end
    end
  end

  describe "#validate_http_url" do
    it "accepts valid HTTP URL" do
      urls = {
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "//sarkodie.com/wp-admin/",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "https://www.grottopress.com/images/hello.png",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "http://www.grottopress.com/images/hi.php",
          param_key: "site"
        )
      }

      urls.each do |url|
        Avram::Validations.validate_http_url url
        url.valid?.should be_true
      end
    end

    it "rejects valid non-HTTP URL" do
      urls = {
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "sftp://www.grottopress.com/contact/",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "ftps://www.grottopress.com/contact/",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "file://www.grottopress.com/contact/",
          param_key: "site"
        )
      }

      urls.each do |url|
        Avram::Validations.validate_http_url url
        url.valid?.should be_false
      end
    end
  end

  describe "#validate_url" do
    it "accepts valid URL" do
      urls = {
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "sarkodie",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "http://sarkodie.com/wp-admin",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "ftps://sarkodie.com/wp-admin",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "file://sarkodie.com/wp-admin",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "//sarkodie.com/wp-admin/",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "https://www.grottopress.com/images/hello.png",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "http://www.grottopress.com/images/hi.php",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "/wp-admin",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "/admin.php?word=hello",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "#weird+but_works",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "#weird+but+works-2",
          param_key: "site"
        )
      }

      urls.each do |url|
        Avram::Validations.validate_url url
        url.valid?.should be_true
      end
    end

    it "rejects invalid URL" do
      urls = {
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "//sarkodie.com/wp-admin/<jak/",
          param_key: "site"
        ),
        Avram::Attribute(String).new(
          :url,
          param: nil,
          value: "https://sarkodie.com/javascript:click/",
          param_key: "site"
        )
      }

      urls.each do |url|
        Avram::Validations.validate_url url
        url.valid?.should be_false
      end
    end
  end

  describe "#validate_slug" do
    it "accepts valid slug" do
      slugs = {
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "sarkodie",
          param_key: "post"
        ),
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "what-a_day",
          param_key: "post"
        ),
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "_WhAt-a-DAY_",
          param_key: "post"
        ),
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "_",
          param_key: "post"
        )
      }

      slugs.each do |slug|
        Avram::Validations.validate_slug slug
        slug.valid?.should be_true
      end
    end

    it "rejects invalid slug" do
      slugs = {
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "-what-a-day",
          param_key: "post"
        ),
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "what-a-day-",
          param_key: "post"
        ),
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "what.a.day",
          param_key: "post"
        ),
        Avram::Attribute(String).new(
          :slug,
          param: nil,
          value: "/what-a-day",
          param_key: "post"
        )
      }

      slugs.each do |slug|
        Avram::Validations.validate_slug slug
        slug.valid?.should be_false
      end
    end
  end

  describe "#validate_primary_key" do
    it "accepts existing ID" do
      user_id = Avram::Attribute(Int64).new(
        :id,
        param: nil,
        value: UserFactory.create.id,
        param_key: "user"
      )

      Avram::Validations.validate_primary_key user_id, query: UserQuery
      user_id.valid?.should be_true
    end

    it "rejectes non-existing ID" do
      user_id = Avram::Attribute(Int64).new(
        :id,
        param: nil,
        value: 45,
        param_key: "user"
      )

      Avram::Validations.validate_primary_key user_id, query: UserQuery
      user_id.valid?.should be_false
    end
  end

  describe "#validate_positive_number" do
    it "accepts postive number" do
      number = Avram::Attribute(Int64).new(
        :age,
        param: nil,
        value: 5,
        param_key: "user"
      )

      Avram::Validations.validate_positive_number number
      number.valid?.should be_true
    end

    it "rejects negative number" do
      number = Avram::Attribute(Int64).new(
        :age,
        param: nil,
        value: -5,
        param_key: "user"
      )

      Avram::Validations.validate_positive_number number
      number.valid?.should be_false
    end
  end

  describe "#validate_not_pwned" do
    it "accepts safe password" do
      response = IO::Memory.new <<-TEXT
        0330BEB91D911BB8680BAE4FF3AFE0530E2:2
        037069DD15159F0BDF6F7AAE2AFA827EAB5:5
        0449BAC928BFA1474E4498A89AECD944A52:3
        04CCD4EA9D14A1ED27B010633E86745A9CB:1
        04D89372AC3DD345C9F858C5F97A86BB941:2
        06069AD3C96CBA5A855734090B94F519BC4:11
        075393E15A29D30D7365640D6A84A160EEF:2
        0777AFC3C0D55CDA8A8D007E9233924B581:1
        078DF28C8B30B46A151297215FC53AF2B7A:6
        07AEDFF9FA3DA39F92344ADB6532F5F7F5D:15
        08EA5DE7C3A765C4F0755FDE8561117CA4A:2
        09E94A79C701D3845A052AB508C9C4E6AF1:1
        09F1B61E9BA766489A2BEE4E03CA8321A3E:2
        0A1CC53F7B21BFF7122D2493A6DB98D748D:1
        0A5F9CCB30538C4337B7BC43DF7077CCB29:1
        TEXT

      WebMock.stub(:get, "https://api.pwnedpasswords.com/range/91613")
        .to_return(body_io: response)

      password = Avram::Attribute(String).new(
        :password,
        param: nil,
        value: "ZWkWBX3deXkU29TdYUeGVh8n",
        param_key: "login"
      )

      Avram::Validations.validate_not_pwned password
      password.valid?.should be_true
    end

    it "rejects unsafe password" do
      response = IO::Memory.new <<-TEXT
        1D2DA4053E34E76F6576ED1DA63134B5E2A:2
        1D72CD07550416C216D8AD296BF5C0AE8E0:10
        1DE027315DE413921A63F1700938AF80965:1
        1E2AAA439972480CEC7F16C795BBB429372:1
        1E3687A61BFCE35F69B7408158101C8E414:1
        1E4C9B93F3F0682250B6CF8331B7EE68FD8:3861493
        1F15311317129463049803B0F5AE31A31C4:1
        1F2B668E8AABEF1C59E9EC6F82E3F3CD786:1
        2028CB7ABE16047F9FFB0699E25655236E0:1
        20597F5AC10A2F67701B4AD1D3A09F72250:3
        20AEBCE40E55EDA1CE07D175EC293150A7E:1
        20FFB975547F6A33C2882CFF8CE2BC49720:1
        21901C19C92442A5B1C45419F7887722FCF:2
        TEXT

      WebMock.stub(:get, "https://api.pwnedpasswords.com/range/5baa6")
        .to_return(body_io: response)

      password = Avram::Attribute(String).new(
        :password,
        param: nil,
        value: "password",
        param_key: "login"
      )

      Avram::Validations.validate_not_pwned password
      password.valid?.should be_false
    end
  end
end
