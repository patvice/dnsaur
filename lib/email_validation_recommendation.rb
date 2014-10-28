require 'pry'
require './email_manipulation.rb'
require 'resolv'

class EmailValidationRecommendation
  include EmailManipulation

  def initialize email, defualt_domain=nil, top_level_defualt=nil
    @defaul_domain = defualt_domain
    @top_level_defualt = top_level_defualt

    @orignal_email = email
    @orignal_email_parts = split_email email

    @suggestion = suggest email
  end

  def valid_dns_corrected_email?
    mx = get_dns @suggestion[:domain]
    mx.size > 0 ? true : false
  end

  def valid_dns_orignal_email?
    mx = get_dns @orinal_email_parts[:domain]
    mx.size > 0 ? true : false
  end

  def valid_dns?
    valid_dns_orignal_email? && valid_dns_corrected_email?
  end

  def self.valid_dns? email
    email_parts = split_email email
    mx = get_dns email_parts[:domain] if !!email_parts
    mx.size > 0 ? true : false
  end

  def suggestion
    @suggestion
  end

  def oringal_email
    @orignal_email_parts
  end

  def valid_email?
    !!(split_email @orignal_email)
  end

  def orignal_dns
    get_dns @orignal_email_parts[:domain]
  end

  def corrected_dns
    get_dns @suggestion[:domain]
  end

  private
  def get_dns domain
    mx = []
    Resolv::DNS.open do |dns|
      mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
    end
    return mx
  end
end

