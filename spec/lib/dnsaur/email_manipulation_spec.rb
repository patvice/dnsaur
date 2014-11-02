require 'spec_helper'

describe EmailManipulation do
  let(:domains) {['scaremonger.co', 'cuspidation.ca', 'telecommunication.org', 'turtlet.com', 'nappiest.uk',
                  'nonstaple.net', 'unfeatured.com', 'cysticerci.org', 'plugging.com', 'example.com'] }

  let(:top_level_domains){ ['aq', 'at', 'bz', 'co', 'eu', 'hk', 'nz', 'su', 'us', 'zw'] }

  class DummyEmailManipulation
  end

  before(:each) do
    @email_manipulation = DummyEmailManipulation.new
    @email_manipulation.extend(EmailManipulation)
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

    context "with a domain list & a top level domain list" do
      it "returns a corrected top level domain out of the list" do
        email = "test@fake.suu"
        suggest_return = {address: "test", domain: "fake.su", full: "test@fake.su"}
        expect(@email_manipulation.suggest email, domains, top_level_domains).to eq(suggest_return)
      end
      it "returns a corrected domain out of the list" do
        email = "test@unfeatred.com"
        suggest_return = {address: "test", domain: "unfeatured.com", full: "test@unfeatured.com"}
        expect(@email_manipulation.suggest email, domains, top_level_domains).to eq(suggest_return)
      end
      it "returns false when the domain is the same a domain in the list of domains" do
        email = "test@scaremonger.co"
        expect(@email_manipulation.suggest email, domains, top_level_domains).to be false
      end
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
      domain = "fake.com"
      expect(@email_manipulation.find_closest_domain domain, domains, 4).to be false
    end
    it "returns nil when there is an exact match" do
      domain = "example.com"
      expect(@email_manipulation.find_closest_domain domain, domains, 4).to be nil
    end
    it "passes a suggestion when there is a differece less then the threshold" do
      domain = "example.c"
      expect(@email_manipulation.find_closest_domain domain, domains, 4).to eq('example.com')
    end
  end
end
