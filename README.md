# BitlyQuickly [![Build Status](https://img.shields.io/travis/ollie/bitly_quickly/master.svg)](https://travis-ci.org/ollie/bitly_quickly) [![Code Climate](https://img.shields.io/codeclimate/github/ollie/bitly_quickly.svg)](https://codeclimate.com/github/ollie/bitly_quickly) [![Gem Version](https://img.shields.io/gem/v/bitly_quickly.svg)](https://rubygems.org/gems/bitly_quickly)

There are many great [bit.ly](https://bitly.com/) gems, it's just that I wanted something as fast and as simple as possible.
It can only shorten URLs. :-)

It uses [Typhoeus](https://github.com/typhoeus/typhoeus) which is an awesome HTTP library for fast
and parallel networking. It also uses [Oj](https://github.com/ohler55/oj) which is a fast JSON parser.

## Installation

Add this line to your application's Gemfile:

    gem 'bitly_quickly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitly_quickly

## Usage

```ruby
client         = BitlyQuickly.new(access_token: 'token')
shortened_url  = client.shorten('http://www.google.com/') # Returns shortened URL.
shortened_urls = client.shorten([                         # Returns original => shortend URL hash.
  'https://www.google.com/',
  'https://www.youtube.com/',
  'https://www.yahoo.com/'
])

shortened_url == 'http://pht.io/1eyUhFo'

shortened_urls == {
  'https://www.yahoo.com/'   => 'http://pht.io/1ezI6Z6',
  'https://www.youtube.com/' => 'http://pht.io/1ezI8Qz',
  'https://www.google.com/'  => 'http://pht.io/1ezI8QA'
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it (https://github.com/ollie/bitly_quickly/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
