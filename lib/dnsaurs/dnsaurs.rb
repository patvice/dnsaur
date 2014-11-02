require "dnsaurs/version"
require "dnsaurs/sift_3_distance"
require "dnsaurs/email_manipulation"

class Dnsaurs
  include EmailManipulation

  attr_accessor :defualt_domain, :top_level_defualt, :original_email

  def initialize email, defualt_domain=nil, top_level_defualt=nil
    if email
      @original_email = email
    else
      raise ArgumentError, "expected a value for email"
    end

    @defaul_domain = defualt_domain
    @top_level_defualt = top_level_defualt

  end

  def self.open(*args)
    dnsaurs = new(*args)
    return dnsaurs unless block_given?
    begin
      yield dnsaurs
    end
  end

  def valid_original_dns?
    Dnsaurs.valid_dns? @original_email
  end

  def valid_suggested_dns?
    Dnsaurs.valid_dns? Dnsaurs.suggest(@original_email, @defualt_domain, @top_level_defualt)[:full]
  end

  def self.valid_dns? email
    email_parts = Dnsaurs.split_email email
    mx = Resolv::DNS.open.getresources(email_parts[:domain], Resolv::DNS::Resource::IN::MX)
    mx.size > 0 ? true : false
  end

  def self.valid_email? email
    !!(Dnsaurs.split_email email)
  end

  def valid_email?
    !!(Dnsaurs.valid_email? @original_email)
  end
end
