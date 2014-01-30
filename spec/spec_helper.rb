require 'simplecov'
require 'webmock/rspec' # Disable all HTTP access

# Coverage tool, needs to be started as soon as possible
SimpleCov.start do
  add_filter '/spec/' # Ignore spec directory
end

require 'bitly_quickly'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, 'https://api-ssl.bitly.com/v3/shorten?access_token=token&longUrl=http://www.google.com/1').
      with(headers: { 'User-Agent' => 'Photolane.co' }).
      to_return(
        status: 200,
        body: '{ "data": [ ], "status_code": 500, "status_txt": "INVALID_ARG_ACCESS_TOKEN" }'
      )

    1.upto(5) do |n|
      stub_request(:get, %(https://api-ssl.bitly.com/v3/shorten?access_token=valid_token&longUrl=http://www.google.com/#{ n })).
        with(headers: { 'User-Agent' => 'Photolane.co' }).
        to_return(
          status: 200,
          body: %({ "status_code": 200, "status_txt": "OK", "data": { "long_url": "http:\/\/www.google.com\/#{ n }", "url": "http:\/\/pht.io\/1eyUhF#{ n }", "hash": "1eyUhFo", "global_hash": "2V6CFi", "new_hash": 0 } })
        )
    end
  end
end
