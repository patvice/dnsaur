require "dnsaur/version"
require "dnsaur/sift_3_distance"
require "dnsaur/email_manipulation"

class Dnsaur
  include EmailManipulation

  attr_reader :original_email

  def initialize email
    if Dnsaur.valid_email? email
      @original_email = email
    else
      raise ArgumentError, "expected a value for email"
    end

    @suggested_email = suggest @original_email
  end

  def self.open(*args)
    dnsaur = new(*args)
    return dnsaur unless block_given?
    begin
      yield dnsaur
    end
  end

  def valid_original_dns?
    Dnsaur.valid_dns? @original_email
  end

  def valid_suggested_dns?
    Dnsaur.valid_dns? @suggested_email[:full]
  end

  def self.valid_dns? email
    email_parts = Dnsaur.split_email email
    mx = Resolv::DNS.open.getresources(email_parts[:domain], Resolv::DNS::Resource::IN::MX)
    mx.size > 0 ? true : false
  end

  def self.valid_email? email
    !!(Dnsaur.split_email email)
  end
end
