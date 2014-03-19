require 'spec_helper'

describe BitlyQuickly do
  it 'fails to make a client' do
    expect { BitlyQuickly.new }.to raise_error
  end

  context 'With access_token' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'access_token' do
      expect(@client.access_token).to eq('token')
    end

    it 'api_address' do
      expect(@client.api_address).to eq(BitlyQuickly::DEFAULT_API_ADDRESS)
    end
  end

  context 'With access_token and api_address' do
    before do
      @client = BitlyQuickly.new access_token: 'token', api_address: 'http://api.bitly.com'
    end

    it 'api_address' do
      expect(@client.api_address).to eq('http://api.bitly.com')
    end
  end

  context 'Methods' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'api_url' do
      expect(@client.api_url('/test')).to eq('https://api-ssl.bitly.com/test')
    end

    it 'makes request' do
      expect(@client.make_shorten_request('http://example.org/1')).to be_kind_of(Typhoeus::Request)
    end
  end

  # Success

  context 'Response with valid token' do
    before do
      @client = BitlyQuickly.new access_token: 'valid_token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://example.org/200/1') }.to_not raise_error
    end

    it 'status code' do
      expect(@client.shorten('http://example.org/200/1')).to eq('http://pht.io/1eyUhF1')
    end
  end

  context 'Many requests' do
    before do
      @client = BitlyQuickly.new access_token: 'valid_token'
    end

    it 'makes many requests' do
      request_urls = [
        'http://example.org/200/1',
        'http://example.org/200/2',
        'http://example.org/200/3',
        'http://example.org/200/4',
        'http://example.org/200/5',
      ]

      response_urls = {
        'http://example.org/200/1' => 'http://pht.io/1eyUhF1',
        'http://example.org/200/2' => 'http://pht.io/1eyUhF2',
        'http://example.org/200/3' => 'http://pht.io/1eyUhF3',
        'http://example.org/200/4' => 'http://pht.io/1eyUhF4',
        'http://example.org/200/5' => 'http://pht.io/1eyUhF5',
      }

      expect(@client.shorten(request_urls)).to eq(response_urls)
    end
  end

  # Errors

  context 'Response 403' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://example.org/403') }.to raise_error(BitlyQuickly::RateLimitExceededError)
    end
  end

  context 'Response 503' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://example.org/503') }.to raise_error(BitlyQuickly::TemporarilyUnavailableError)
    end
  end

  context 'Response 404' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://example.org/404') }.to raise_error(BitlyQuickly::NotFoundError)
    end
  end

  context 'Response 500' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://example.org/500') }.to raise_error(BitlyQuickly::InvalidRequestOrResponseError)
    end
  end

  context 'Response 666' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://example.org/666') }.to raise_error(BitlyQuickly::UnknownError)
    end
  end
end
