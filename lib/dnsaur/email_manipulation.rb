require 'pry'

module EmailManipulation
  include Sift3Distance

  DOMAIN_THRESHOLD = 4
  TOP_LEVEL_THRESHOLD = 3
  DEFAULT_ERROR = "default domains list can't be nil or empty"
  TOP_LEVEL_ERROR = "default top level domains can't be nil or empty"


  @@default_domains = ["yahoo.com", "google.com", "hotmail.com", "gmail.com", "me.com", "aol.com", "mac.com",
                       "live.com", "comcast.net", "googlemail.com", "msn.com", "hotmail.co.uk", "yahoo.co.uk",
                       "facebook.com", "verizon.net", "sbcglobal.net", "att.net", "gmx.com", "mail.com",
                       "outlook.com", "icloud.com"]

  @@default_top_level_domains = ["co.jp", "co.uk", "com", "net", "org", "info", "edu", "gov", "mil", "ca"]

  def default_domains
    @@default_domains
  end

  def default_domains= domains
    raise ArgumentError, DEFAULT_ERROR if domains.nil? || domains.empty?
    @@default_domains = domains
  end

  def default_top_level_domains
    @@default_top_level_domains
  end

  def default_top_level_domains= top_level_domains
    raise ArgumentError, TOP_LEVEL_ERROR if top_level_domains.nil? || top_level_domains.empty?
    @@default_top_level_domains = top_level_domains
  end

  def suggest email
    email_parts = self.split_email(email)
    closest_domain = self.find_closest_domain(email_parts[:domain], @@default_domains, DOMAIN_THRESHOLD)

    if closest_domain
      if closest_domain != email_parts[:domain]
        return { address: email_parts[:address], domain: closest_domain, full: email_parts[:address] + "@" + closest_domain }
      end
    else
      closest_top_level_domain = self.find_closest_domain(email_parts[:top_level_domain], @@default_top_level_domains, TOP_LEVEL_THRESHOLD)

      if closest_top_level_domain && closest_top_level_domain != email_parts[:top_level_domain]
        closest_domain = email_parts[:domain].split('.', 2).first + '.' + closest_top_level_domain

        return { address: email_parts[:address], domain: closest_domain, full: email_parts[:address] + "@" + closest_domain }
      end
    end

    return false
  end

  def split_email email
    parts = email.downcase.split('@')

    return false if parts.length < 2 || parts.include?('')

    address = parts.first
    domain = parts.last
    top_level_domain = domain.split('.', 2).last

    return {top_level_domain: top_level_domain, domain: domain, address: address}
  end

  def find_closest_domain domain, domains, threshold
    min_distance = 99
    closest_domain = nil

    return false if !domain || !domains

    domains.each do |d|
      if domain == d
        return
      end
      dist = self.sift_3_distance(domain, d)
      if (dist < min_distance)
        min_distance = dist
        closest_domain = d
      end
    end

    if min_distance <= threshold && !closest_domain.nil?
      return closest_domain
    else
      return false
    end
  end

  def self.included(base)
    base.extend(EmailManipulation)
  end
end
