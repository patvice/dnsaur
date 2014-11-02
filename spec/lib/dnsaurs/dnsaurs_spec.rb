require 'spec_helper'

describe Dnsaurs do
  let(:domains) {['scaremonger.co', 'cuspidation.ca', 'telecommunication.org', 'turtlet.com', 'nappiest.uk',
                  'nonstaple.net', 'unfeatured.com', 'cysticerci.org', 'plugging.com', 'example.com'] }

  let(:top_level_domains){ ['aq', 'at', 'bz', 'co', 'eu', 'hk', 'nz', 'su', 'us', 'zw'] }

  describe "initialize" do

  end
  context "class methods" do
    describe "::valid_dns?" do
      it "returns true when there reverse DNS lookup returns MX" do
        email = "test@example.com"
        Resolv::DNS.stub_chain(:open, :getresources).and_return ['true', 'true']
        expect(Dnsaurs.valid_dns? email).to be true
      end
      it "returns false when there is no MX for that domain" do
        email = "test@example.com"
        Resolv::DNS.stub_chain(:open, :getresources).and_return []
        expect(Dnsaurs.valid_dns? email).to be false
      end
    end

    describe "::valid_email?" do
      it "returns true when the email format is valid" do
        email = "test@example.com"
        expect(Dnsaurs.valid_email? email).to be true
      end
      it "returns false when the email format is not valid" do
        email = "test@"
        expect(Dnsaurs.valid_email? email).to be false
      end
    end
  end

  context 'instance methods' do
    before do
      @dnsaurs = Dnsaurs.new "test@example.com", domains, top_level_domains
    end

    describe "#valid_original_dns?" do
      it "returns true when there reverse DNS lookup returns MX" do
        Resolv::DNS.stub_chain(:open, :getresources).and_return ['true', 'true']
        expect(@dnsaurs.valid_original_dns?).to be true
      end
      it "returns fail when there is no MX for that domain" do
        Resolv::DNS.stub_chain(:open, :getresources).and_return []
        expect(@dnsaurs.valid_original_dns?).to be false
      end
    end
    describe "#valid_suggested_dns?" do
      it "returns true when there reverse DNS lookup returns MX" do
        Resolv::DNS.stub_chain(:open, :getresources).and_return ['true', 'true']
        expect(@dnsaurs.valid_suggested_dns?).to be true
      end
      it "returns false when there is no MX for that domain" do
        Resolv::DNS.stub_chain(:open, :getresources).and_return []
        expect(@dnsaurs.valid_suggested_dns?).to be false
      end
    end

    describe "#valid_email?" do
      it "returns true when the email format is valid" do
        email = "test@example.com"
        expect(@dnsaurs.valid_email?).to be true
      end
      it "returns false when the email format is not valid" do
        email = "test@"
        @new_dnsaurs = Dnsaurs.new email
        expect(@new_dnsaurs.valid_email?).to be false
      end
    end
  end
end
