require 'spec_helper'

describe EmailManipulation do
  let(:domains) {["yahoo.com", "google.com", "hotmail.com", "gmail.com", "me.com", "aol.com", "mac.com",
                  "live.com", "comcast.net", "googlemail.com", "msn.com", "hotmail.co.uk", "yahoo.co.uk",
                  "facebook.com", "verizon.net", "sbcglobal.net", "att.net", "gmx.com", "mail.com",
                  "outlook.com", "icloud.com"] }

  let(:top_level_domains){ ["co.jp", "co.uk", "com", "net", "org", "info", "edu", "gov", "mil", "ca"] }

  class DummyEmailManipulation
  end

  before(:each) do
    @email_manipulation = DummyEmailManipulation.new
    @email_manipulation.extend(EmailManipulation)
  end
  after(:each) do
    @email_manipulation.default_domains = domains
    @email_manipulation.default_top_level_domains = top_level_domains
  end

  describe "#default_domains" do
    it "returns a list of domains" do
      expect(@email_manipulation.default_domains).to be_truthy
    end
  end

  describe "#default_domains=" do
    it "assigns a new set of domains" do
      domain_list = ['example.com', 'fake.org']
      @email_manipulation.default_domains= domain_list
      expect(@email_manipulation.default_domains).to eq(domain_list)
    end
    it "raise an error when passed an empty array" do
      domain_list = []
      expect{@email_manipulation.default_domains= domain_list}.to raise_error
    end
    it "raises an error when passed nil" do
      domain_list = nil
      expect{@email_manipulation.default_domains= domain_list}.to raise_error
    end
  end

  describe "#default_top_level_domains" do
    it "returns a list of top_level_domains" do
      expect(@email_manipulation.default_top_level_domains).to be_truthy
    end
  end

  describe "#default_top_level_domains=" do
    it "assigns a new set of domains" do
      tldomain_list = ['example.com', 'fake.org']
      @email_manipulation.default_top_level_domains= tldomain_list
      expect(@email_manipulation.default_top_level_domains).to eq(tldomain_list)
    end
    it "raise an error when passed an empty array" do
      tldomain_list = []
      expect{@email_manipulation.default_top_level_domains= tldomain_list}.to raise_error
    end
    it "raises an error when passed nil" do
      tldomain_list = nil
      expect{@email_manipulation.default_top_level_domains= tldomain_list}.to raise_error
    end
  end

  describe "#suggest" do
    it "returns a corrected top level domain" do
      email = "test@example.con"
      suggest_return = {address: "test", domain: "example.com", full: "test@example.com"}
      expect(@email_manipulation.suggest email).to eq(suggest_return)
    end
    it "returns a corrected domain" do
      email = "test@hotnail.con"
      suggest_return = {address: "test", domain: "hotmail.com", full: "test@hotmail.com"}
      expect(@email_manipulation.suggest email).to eq(suggest_return)
    end
    it "returns false when a email doesn't match default domains" do
      email = "test@example.com"
      expect(@email_manipulation.suggest email).to be false
    end
  end

  describe "#domain_suggestion" do
    it "returns a corrected domain" do
      domain = "hotnail.com"
      expect(@email_manipulation.domain_suggestion(domain)).to eq('hotmail.com')
    end
    it "returns false if domain is valid" do
      domain = "hotmail.com"
      expect(@email_manipulation.domain_suggestion(domain)).to eq(false)
    end
    it "returns false if there are no suggestions" do
      allow(@email_manipulation).to receive(:find_closest_domain).and_return false
      domain = "notacommondomain.com"
      expect(@email_manipulation.domain_suggestion(domain)).to eq(false)
    end
  end

  describe "#tld_suggestion" do
    it "returns a domain with corrected tld" do
      domain = "example.con"
      tld = "con"
      expect(@email_manipulation.tld_suggestion(domain, tld)).to eq('example.com')
    end
    it "returns false if tld is valid" do
      domain = "example.com"
      tld = "com"
      expect(@email_manipulation.tld_suggestion(domain, tld)).to eq(false)
    end
    it "returns false if suggestion is not found" do
      allow(@email_manipulation).to receive(:find_closest_domain).and_return false
      domain = "example.faketld"
      tld = "faketld"
      expect(@email_manipulation.tld_suggestion(domain, tld)).to eq(false)
    end
  end

  describe "#format_suggested_email" do
    it "returns a hash with address" do
      address = "test"
      domain = "hotmail.com"
      suggest_return = {address: address, domain: domain, full: "#{address}@#{domain}"}
      expect(@email_manipulation.format_suggested_email(address, domain)).to eq(suggest_return)
    end

  end

  describe "#split_email" do
    it "splits an email into three parts" do
      email = 'test@example.com'
      split_return = {top_level_domain: 'com',domain: 'example.com', address: 'test'}
      expect(@email_manipulation.split_email email).to eq(split_return)
    end
    it "returns the same top level domain/domain when givin an domain without a top level domain" do
      #this is actually a valid email, according
      email = 'test@example'
      split_return = {:top_level_domain=>"example", :domain=>"example", :address=>"test"}
      expect(@email_manipulation.split_email email).to eq(split_return)
    end
    it "returns false if the email doesn't have a domain" do
      email = 'test@'
      expect(@email_manipulation.split_email email).to be false
    end
    it "returns false if there is no @ symbol in the string" do
      email = 'test'
      expect(@email_manipulation.split_email email).to be false
    end
  end

  describe "#find_closest_domain" do
    it "returns false when passed nil attributes" do
      expect(@email_manipulation.find_closest_domain nil, nil, 4).to be false
    end
    it "returns false when there is no match" do
      domain = "example.com"
      expect(@email_manipulation.find_closest_domain domain, domains, 4).to be false
    end
    it "returns nil when there is an exact match" do
      domain = "hotmail.com"
      expect(@email_manipulation.find_closest_domain domain, domains, 4).to be nil
    end
    it "passes a suggestion when there is a differece less then the threshold" do
      domain = "hotmail.c"
      expect(@email_manipulation.find_closest_domain domain, domains, 4).to eq('hotmail.com')
    end
  end
end
