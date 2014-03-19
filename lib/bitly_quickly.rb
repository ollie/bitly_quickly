require 'typhoeus'
require 'oj'

require 'bitly_quickly/version'

# V3 Wrapper
class BitlyQuickly
  class BitlyError                    < StandardError; end
  class RateLimitExceededError        < BitlyError; end # 403
  class TemporarilyUnavailableError   < BitlyError; end # 503
  class NotFoundError                 < BitlyError; end # 404
  class InvalidRequestOrResponseError < BitlyError; end # 500
  class UnknownError                  < BitlyError; end

  DEFAULT_API_ADDRESS = 'https://api-ssl.bitly.com'
  OJ_OPTIONS          = {
    mode:             :compat,     # Converts values with to_hash or to_json
    symbol_keys:      true,        # Symbol keys to string keys
    time_format:      :xmlschema,  # ISO8061 format
    second_precision: 0,           # No include milliseconds
  }

  attr_reader :access_token,
              :api_address

  def initialize(options)
    @access_token = options.delete(:access_token) || raise( ArgumentError.new('Missing access_token option') )
    @api_address  = options.delete(:api_address)  || DEFAULT_API_ADDRESS
  end

  def shorten(long_url_or_array)
    if long_url_or_array.respond_to? :each
      get_many_responses long_url_or_array
    else
      get_single_response long_url_or_array
    end
  end

  def get_many_responses(array_of_long_urls)
    hydra     = Typhoeus::Hydra.new
    responses = {}

    array_of_long_urls.each do |long_url|
      request = make_shorten_request long_url

      request.on_complete do |response|
        json_response = response_to_json response
        responses[ response.request.long_url ] = json_response[:data][:url]
      end

      hydra.queue request
    end

    hydra.run
    responses
  end

  def get_single_response(long_url)
    response = get_response long_url
    response[:data][:url]
  end

  def api_url(path)
    URI.join(api_address, path).to_s
  end

  def make_shorten_request(long_url)
    request = Typhoeus::Request.new(
      api_url('/v3/shorten'),
      {
        params: {
          access_token: access_token,
          longUrl:      long_url
        },
      }
    )

    # I need to access this later in the result
    class << request
      attr_accessor :long_url
    end

    request.long_url = long_url
    request
  end

  def get_response(long_url)
    request  = make_shorten_request long_url
    response = request.run
    response_to_json response
  end

  def response_to_json(response)
    json_response = parse_response response

    case json_response[:status_code]
    when 200
      return json_response
    when 403
      raise RateLimitExceededError, json_response[:status_txt]
    when 404
      raise NotFoundError, json_response[:status_txt]
    when 500
      raise InvalidRequestOrResponseError, json_response[:status_txt]
    when 503
      raise TemporarilyUnavailableError, json_response[:status_txt]
    else
      raise UnknownError, json_response[:status_txt]
    end
  end

  def parse_response(response)
    Oj.load response.body, OJ_OPTIONS
  end
end
