require 'typhoeus'
require 'multi_json'

require 'bitly_quickly/version'
require 'bitly_quickly/error'

# Wrapper around Bitly V3 API.
#
# @example
#   client         = BitlyQuickly.new(access_token: 'token')
#   shortened_url  = client.shorten('http://www.google.com/')
#   shortened_urls = client.shorten([
#     'https://www.google.com/',
#     'https://www.youtube.com/',
#     'https://www.yahoo.com/'
#   ])
#
#   shortened_url == 'http://pht.io/1eyUhFo'
#
#   shortened_urls == {
#     'https://www.yahoo.com/'   => 'http://pht.io/1ezI6Z6',
#     'https://www.youtube.com/' => 'http://pht.io/1ezI8Qz',
#     'https://www.google.com/'  => 'http://pht.io/1ezI8QA'
#   }
class BitlyQuickly
  # Bitly API server.
  DEFAULT_API_ADDRESS = 'https://api-ssl.bitly.com'

  # API Access Token.
  #
  # @return [String]
  attr_reader :access_token

  # Alternate API server URL.
  #
  # @return [String]
  attr_reader :api_address

  # Init with access token and api address.
  #
  # @param  config [Hash]                 Config settings.
  # @option config :access_token [String] API Access Token.
  # @option config :api_address  [String] Alternate API server URL, optional.
  def initialize(config)
    @access_token = config.delete(:access_token) || fail(
      ArgumentError, 'Missing access_token option'
    )

    @api_address = config.delete(:api_address) || DEFAULT_API_ADDRESS
  end

  # Shorten URL or array of URLs. In case single URL is passed, it returns
  # the shortened URL. If an array is passed, it returns a hash where keys
  # are original URLs and values are shortened URLs.
  #
  # @param long_url_or_array [String, Array<String>]
  #
  # @return [String, Hash<String, String>]
  def shorten(long_url_or_array)
    if long_url_or_array.respond_to?(:each)
      get_many_responses(long_url_or_array)
    else
      get_single_response(long_url_or_array)
    end
  end

  # Create endpoint URL.
  #
  # @param path [String] Endpoint path.
  #
  # @return [String] Endpoint URL.
  def endpoint_url(path)
    URI.join(api_address, path).to_s
  end

  ##########################
  # Private instance methods
  ##########################

  private

  # Shorten each URL and return a hash where keys
  # are original URLs and values are shortened URLs.
  #
  # @param array_of_long_urls [String, Array<String>]
  #
  # @return [Hash<String, String>]
  def get_many_responses(array_of_long_urls)
    hydra     = Typhoeus::Hydra.new
    responses = {}

    array_of_long_urls.each do |long_url|
      request = make_shorten_request(long_url)

      request.on_complete do |response|
        json_response       = response_to_json(response)
        responses[long_url] = json_response[:data][:url]
      end

      hydra.queue request
    end

    hydra.run
    responses
  end

  # Shorten single URL.
  #
  # @param long_url [String] Original URL.
  #
  # @return [String] Shortened URL.
  def get_single_response(long_url)
    request       = make_shorten_request(long_url)
    response      = request.run
    json_response = response_to_json(response)

    json_response[:data][:url]
  end

  # Prepare Typhoeus shorten request.
  #
  # @param long_url [String] Original URL.
  #
  # @return [Typhoues::Request]
  def make_shorten_request(long_url)
    Typhoeus::Request.new(
      endpoint_url('/v3/shorten'),
      params: {
        access_token: access_token,
        longUrl:      long_url
      }
    )
  end

  # Check response code and raise an appropriate error.
  # Otherwise return parsed JSON body.
  #
  # @param response [Typhoues::Response]
  #
  # @return [Hash]
  def response_to_json(response)
    json_response = parse_json(response.body)

    case json_response[:status_code]
    when 200
      return json_response
    when 403
      fail Error::RateLimitExceeded, json_response[:status_txt]
    when 404
      fail Error::NotFound, json_response[:status_txt]
    when 500
      fail Error::InvalidRequestOrResponse, json_response[:status_txt]
    when 503
      fail Error::TemporarilyUnavailable, json_response[:status_txt]
    else
      fail Error::UnknownError, json_response[:status_txt]
    end
  end

  # Parse JSON string into Ruby hash.
  #
  # @param json [String] JSON string.
  #
  # @return [Hash]
  def parse_json(json)
    MultiJson.load(json, symbolize_keys: true)
  end
end
