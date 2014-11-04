require "dnsaur/version"
require "dnsaur/sift_3_distance"
require "dnsaur/email_manipulation"

class Dnsaur
  include EmailManipulation

  ARG_ERROR = "An email can not be empty or invalid"
  attr_reader :original_email

  def initialize email
    if Dnsaur.valid_email? email
      @original_email = email
    else
      raise ArgumentError, ARG_ERROR
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

  def original_email
    @original_email
  end

  def original_email= email
    raise ArgumentError, ARG_ERROR unless Dnsaur.valid_email? email
    @original_email = email
    @suggested_email = suggest email
  end

  def suggested_email
    return false unless @suggested_email
    @suggested_email[:full] if @suggested_email
  end

  def valid_original_dns?
    Dnsaur.valid_dns? @original_email
  end

  def valid_suggested_dns?
    return false unless @suggested_email
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
