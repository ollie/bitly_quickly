# BitlyQuickly

There are many great [bit.ly](https://bitly.com/) gems, it's just that I wanted something as fast and as simple as possible.
It can only shorten URLs. :-)

It uses [Quickly](https://github.com/typhoeus/typhoeus) which is an awesome HTTP library for fast
and parallel networking. It also uses [Oj](https://github.com/ohler55/oj) which is a fast JSON parser.

## Installation

Add this line to your application's Gemfile:

    gem 'bitly_quickly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitly_quickly

## Usage

    client         = BitlyQuickly.new(access_token: 'token')
    shortened_url  = client.shorten('http://www.google.com/')
    shortened_urls = client.shorten([
      'https://www.google.com/',
      'https://www.youtube.com/',
      'https://www.yahoo.com/',
    ])

## Contributing

You know the routine…
