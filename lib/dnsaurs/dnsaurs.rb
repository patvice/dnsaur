require "./version.rb"
require "./sift_3_distance.rb"
require "./email_manipulation.rb"
require "resolv"

class Dnsaurs
  include EmailManipulation

  attr_accessor :defualt_domain, :top_level_defualt, :orignal_email

  def initialize email, defualt_domain=nil, top_level_defualt=nil
    if email
      @orignal_email = email
    else
      raise ArgumentError, "expected a value for email"
    end

    @defaul_domain = defualt_domain
    @top_level_defualt = top_level_defualt

    @suggested_email = Dnsaurs.suggest @orignal_email, @defualt_domain, @top_level_defualt
  end

  def self.open(*args)
    dnsaurs = new(*args)
    return dnsaurs unless block_given?
    begin
      yield dnsaurs
    end
  end

  def valid_original_dns?
    Dnsaurs.valid_dns? @orignal_email
  end

  def valid_suggested_dns?
    Dnsaurs.valid_dns? @suggested_email
  end

  def self.valid_dns? email
    email_parts = Dnsaurs.split_email email
    mx = Resolv::DNS.open.getresources(email_parts[:domain], Resolv::DNS::Resource::IN::MX)
    mx.size > 0 ? true : false
  end

  def self.valid_email? email
    !!(split_email @orignal_email)
  end

  def valid_email?
    Dnsaurs.valid_email? @orignal_email
  end
end
