require 'spec_helper'

describe EmailManipulationModule do
  extend EmailManipulation
  let(:domains) {['scaremonger.com', 'cuspidation.ca', 'telecommunication.org', 'turtlet.com', 'nappiest.uk'
                  'nonstaple.net', 'unfeatured.com', 'cysticerci.org', 'plugging.com', 'example.com'] }

  let(:top_level_domains){ ['aq', 'at', 'bz', 'co', 'eu', 'hk', 'nz', 'su', 'us', 'zw'] }

  describe "#suggest" do
    it "returns a corrected top level domain" do
      email = "test@example.con"
      suggest_return = {address: "test", domain: "example.com", full: "test@example.com"}
      expect(EmailManipulation.suggest email).to eq(suggest_return)
    end
    it "returns a corrected domain" do
      email = "test@hotnail.con"
      suggest_return = {address: "test", domain: "hotmail.com", full: "test@hotmail.com"}
      expect(EmailManipulation.suggest email).to eq(suggest_return)
    end
    it "returns false when a email doesn't match default domains" do
      email = "test@example.com"
      expect(EmailManipulation.suggest email).to be_false
    end

    context "with a domain list & a top level domain list" do

      it "returns a corrected top level domain out of the list" do
        email = "test@example.suu"
        suggest_return = {address: "test", domain: "example.su", full: "test@example.su"}
        expect(EmailManipulation.suggest email, domains, top_level_domains).to eq(suggest_return)
      end
      it "returns a corrected domain" do
        email = "test@unfeatred.com"
        suggest_return = {address: "test", domain: "unfeatured.com", full: "test@unfeatured.com"}
        expect(EmailManipulation.suggest email, domains, top_level_domains).to eq(suggest_return)
      end
      it "returns false when a email donesn't match default domains" do
        email = "test@scaremonger.com"
        expected(EmailManipulation.suggest email, domains, top_level_domains).to be_false
      end
    end
  end

  describe "#split_email" do
    it "splits an email into three parts" do
      email = 'test@example.com'
      split_return = {top_level_domain: 'com',domain: 'example.com', address: 'test@example.com'}
      expected(EmailManipulation.split_email email).to eq(split_return)
    end
    it "returns false if the email is invalid" do
      email 'test@example'
      expected(EmailManipulation.split_email email).to be_false
    end
    it "returns false if the email doesn't have a domain" do
      email = 'test@'
      expected(EmailManipulation.split_email email).to be_false
    end
    it "returns false if there is no @ symbol in the string" do
      email = 'test'
      expected(EmailManipulation.split_email email).to be_false
    end
  end

  describe "#find_closet_domain" do
    it "returns false when passed nil attributes" do
      expected(EmailManipulation.find_closet_domain nil, nil, 4).to be_false
    end
    it "returns false when there is no match" do
      domain = "example.com"
      expected(EmailManipulation.find_closet_domain domain, domains, 4).to be_false
    end
    it "passes a suggestion when there is a differece less then the threshold" do
      domain = "example.c"
      expect(EmailManipulation.find_closet_domain domain, domains, 4).to eq('example.com')
    end
  end
end
