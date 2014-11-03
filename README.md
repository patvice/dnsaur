#Dnsaur

Dnsaur is a simple DNS checker / email corrector for ruby. When a user misspells a domain, it suggests
the right spelling, as well as provide simple reverse DNS helper methods to help verifiy these emails.

The email suggestion part of the gem is based off a small javascript library called
[mailcheck.js](https://github.com/mailcheck/mailcheck). If you are looking for a more front end
solution for correcting email input, I suggest checking this out.

## How it works

When your user types in "user@hotnail.con", Dnsaur will suggest "user@hotmail.com". It can also
suggest top level domains, where a user types "user@hotmail.cmo" and would suggest ".com"

It does this by comparing a list of popular default domains and defualt top level domains suplied to
the gem.

## Usage
Dnsaur can be used ether as an instances or as class methods. When created an instance you need to
supply it with email,
```ruby
email = "test@example.com"
dns = Dnsaur.new email
=> #<Dnsaur:0x007fb8ea17d590 @original_email="test@example.com", ...
```
custom domains and/or custom top level domains are optional.

Dnsaur supplies three different uses,

1. Email Suggestion/Correction

In the suggest method, you can pass an email and it will return a suggested email in a hash
example:
```ruby
# Class Methods
email = "test@hotnail.con"
Dnsaur.suggest email
=>
{
  address:          'test',             // the address; part before the @ sign
  domain:           'hotmail.com',      // the suggested domain
  top_level_domain: 'com',              // the suggested top level domain
  full:             'test@hotmail.com'  // the full suggested email
}
```
If there is no match, or it is an exact match to a defualt domain, it will return false.

2. Reverse DNS lookup Helpers

The DNS lookup for this gem uses `Resolv` from the ruby stdlib, but I supplied class/instanced helper methods
for ease of use. If you have an instances of the class, it
```ruby
#Class Methods
email = "test@example.com"
Dnsaur.valid_dns? email
=> true || false

#Instant Methods
email = "test@hotnail.com"
dns = Dnsaur.new email
dns.valid_original_dns?
=> true || false

dns.valid_suggested_email?
=> true || false
```

3. Split and Vaild Emails

The split_email method is used to split the email into three parts
```ruby
email = "test@exmaple.com"
Dnsaur.split_email email
{
  top_level_domain: 'com',         // the top level domain
  domain:           'example.com', // the domain
  address:          'test'         // the address; part before the @ sign
}
```

## Domains
Just like [mailcheck.js](https://github.com/mailcheck/mailcheck), you can and should give Dnsaur
a custom list of domains/top level domains that your user will most likely use to sign up.

This can be done in two different way, ether by giving a completly new list and passing it
into and instance:
```ruby
email = "test@example.com"
domains = ['customdomain.com', 'anotherdomain.net']
top_level_domains = ['com.au', 'ru']

Dnsaur.default_domains = domains
Dnsaur.default_top_level_domains = top_level_domains

Dnsaur.default_domains
=> ["customdomain.com", "anotherdomain.net"]
Dnsaur.default_top_level_domains
=> ["com.au", "ru"]
```

Or if you want to just add values to the default domains provided,
you can pushing new values into the class constants:
```ruby
Dnsaur.default_domains.push('customdomain.com', 'anotherdomain.net')
Dnsaur.default_top_level_domains.push('com.au', 'ru')
```

`default_domains` and `default_top_level_domains` are class members, so once change all the instances of this class will have
your custom list of domains

## Installation

Add this line to your application's Gemfile:

    gem 'dnsaur'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dnsaur

## Still left Todo

There is still alot of polish that I would like to do to the code in this gem, and I would
also like to add some more functionality for validating emails:

- More test, and better test for all specs
- RFC822 regexp-based to be able to validate emails. [link](http://ex-parrot.com/~pdw/Mail-RFC822-Address.html)
- Using STMP VRFY command as well as RCTP TO: for better DNS validation
- Improve suggest methods readlity, and usablity

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dnsaur/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
