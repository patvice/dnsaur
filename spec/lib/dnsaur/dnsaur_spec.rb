require 'spec_helper'

describe Dnsaur do

  describe "::initialize" do
    it "when the email is invalid it raises an error" do
      email = ""
      expect{ Dnsaur.new email }.to raise_error(ArgumentError)
    end
    it "suggests an email when it being initialized" do
      email = "test@hotnail.con"
      dns = Dnsaur.new email
      expect(dns.suggested_email).to be_truthy
    end
  end

  context "class methods" do

    describe "::valid_dns?" do
      it "returns true when there reverse DNS lookup returns MX" do
        email = "test@example.com"
        allow(Resolv::DNS).to receive_message_chain(:open, :getresources).and_return ['true', 'true']
        expect(Dnsaur.valid_dns? email).to be true
      end
      it "returns false when there is no MX for that domain" do
        email = "test@example.com"
        allow(Resolv::DNS).to receive_message_chain(:open, :getresources).and_return []
        expect(Dnsaur.valid_dns? email).to be false
      end
    end

    describe "::valid_email?" do
      it "returns true when the email format is valid" do
        email = "test@example.com"
        expect(Dnsaur.valid_email? email).to be true
      end
      it "returns false when the email format is not valid" do
        email = "test@"
        expect(Dnsaur.valid_email? email).to be false
      end
    end
  end

  context 'instance methods' do
    before do
      @dnsaur = Dnsaur.new "test@hotnail.com"
    end

    describe "#original_email" do
     it "returns an email given when a new instance is created" do
        expect(@dnsaur.original_email).to eq("test@hotnail.com")
      end
    end

    describe "#original_email=" do
      it "sets a new email for that object" do
        email = "test@example.com"
        @dnsaur.original_email = email
        expect(@dnsaur.original_email).to eq(email)
      end
      it "sets a new suggestion when an email is changed" do
        email = "test@example.com"
        @dnsaur.original_email = email
        expect(@dnsaur.suggested_email).to be_falsey
      end
      it "raises an error when trying to change to an invalid email" do
        email = "test@"
        expect{@dnsaur.original_email= email}.to raise_error(ArgumentError)
      end
    end

    describe "#suggested_email" do
      it "returns a suggested email" do
        expect(@dnsaur.suggested_email).to eq('test@hotmail.com')
      end
      it "it returns false if there is not suggest" do
        email = "test@example.com"
        @dnsaur.original_email = email
        expect(@dnsaur.suggested_email).to be_falsey
      end
    end

    describe "#valid_original_dns?" do
      it "returns true when reverse DNS lookup returns MX" do
        allow(Resolv::DNS).to receive_message_chain(:open, :getresources).and_return ['true', 'true']
        expect(@dnsaur.valid_original_dns?).to be true
      end
      it "returns fail when there is no MX for that domain" do
        allow(Resolv::DNS).to receive_message_chain(:open, :getresources).and_return []
        expect(@dnsaur.valid_original_dns?).to be false
      end
    end

    describe "#valid_suggested_dns?" do
      it "returns true when there reverse DNS lookup returns MX" do
        allow(Resolv::DNS).to receive_message_chain(:open, :getresources).and_return ['true', 'true']
        expect(@dnsaur.valid_suggested_dns?).to be true
      end
      it "returns false when there is no MX for that domain" do
        allow(Resolv::DNS).to receive_message_chain(:open, :getresources).and_return []
        expect(@dnsaur.valid_suggested_dns?).to be false
      end
    end
  end
end
