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
  end

  def self.open(*args)
    dnsaurs = new(*args)
    return dnsaurs unless block_given?
    begin
      yield dnsaurs
    end
  end

  def valid_original_dns?
    email_parts = self.split_email @@orignal_email
    mx = get_dns email_parts[:domain]
    mx.size > 0 ? true : false
  end

  def valid_suggested_dns?
    mx = get_dns suggested_email_parts[:domain]
    mx.size > 0 ? true : false
  end

  def valid_email?
    !!(split_email @orignal_email)
  end
  private
  def get_dns domain
    Resolv::DNS.open.getresources(domain, Resolv::DNS::Resource::IN::MX)
  end
end

