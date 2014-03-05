# BitlyQuickly

[![Build Status](https://travis-ci.org/ollie/bitly_quickly.png?branch=master)](https://travis-ci.org/ollie/bitly_quickly)

There are many great [bit.ly](https://bitly.com/) gems, it's just that I wanted something as fast and as simple as possible.
It can only shorten URLs. :-)

It uses [Typhoeus](https://github.com/typhoeus/typhoeus) which is an awesome HTTP library for fast
and parallel networking. It also uses [Oj](https://github.com/ohler55/oj) which is a fast JSON parser.

## Tested on

* 2.1.1
* 2.1.0
* 2.0.0
* 1.9.3

## Installation

Add this line to your application's Gemfile:

    gem 'bitly_quickly'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitly_quickly

## Usage

    client         = BitlyQuickly.new(access_token: 'token')
    shortened_url  = client.shorten('http://www.google.com/') # returns String
    shortened_urls = client.shorten([                         # returns Hash
      'https://www.google.com/',
      'https://www.youtube.com/',
      'https://www.yahoo.com/',
    ])

## Contributing

You know the routine…
