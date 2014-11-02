module EmailManipulation
  include Sift3Distance

  DOMAIN_THRESHOLD = 4
  TOP_LEVEL_THRESHOLD = 3

  DEFAULT_DOMAINS = ["yahoo.com", "google.com", "hotmail.com", "gmail.com", "me.com", "aol.com", "mac.com",
                     "live.com", "comcast.net", "googlemail.com", "msn.com", "hotmail.co.uk", "yahoo.co.uk",
                     "facebook.com", "verizon.net", "sbcglobal.net", "att.net", "gmx.com", "mail.com",
                     "outlook.com", "icloud.com"]

  DEFAULT_TOP_LEVEL_DOMAINS = ["co.jp", "co.uk", "com", "net", "org", "info", "edu", "gov", "mil", "ca"]

  def suggest email, domains=nil, top_level_domains=nil

    domains ||= DEFAULT_DOMAINS
    top_level_domains ||= DEFAULT_TOP_LEVEL_DOMAINS

    email = email.downcase
    email_parts = self.split_email(email)

    closest_domain = self.find_closest_domain(email_parts[:domain], domains, DOMAIN_THRESHOLD)

    if closest_domain
      if closest_domain != email_parts[:domain]
        return { address: email_parts[:address], domain: closest_domain, full: email_parts[:address] + "@" + closest_domain }
      end
    else
      closest_top_level_domain = self.find_closest_domain(email_parts[:top_level_domain], top_level_domains, TOP_LEVEL_THRESHOLD)
      if email_parts[:domain] && closest_top_level_domain && closest_top_level_domain != email_parts[:top_level_domain]

        domain = email_parts[:domain];
        closest_domain = domain[0..(domain.index(email_parts[:top_level_domain])-1)] + closest_top_level_domain

        return { address: email_parts[:address], domain: closest_domain, full: email_parts[:address] + "@" + closest_domain }
      end
    end

    return false
  end

  def split_email email
    parts = email.split('@')

    return false if parts.length < 2

    parts.each do |part|
      return false if part == ''
    end

    address = parts[0]
    domain = parts.pop()
    domain_parts = domain.split('.')
    tld = String.new

    if domain_parts.length == 0
      return false
    elsif domain_parts.length == 1
      tld = domain_parts[0]
    else
      for i in 1..domain_parts.length-1
        tld += domain_parts[i] + '.'
      end
      tld = tld[0..(tld.length-2)] if domain_parts.length >= 2
    end

    return {top_level_domain: tld, domain: domain, address: address}
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
