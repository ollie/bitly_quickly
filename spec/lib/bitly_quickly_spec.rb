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
      expect(@client.make_shorten_request('http://www.google.com/1')).to be_kind_of(Typhoeus::Request)
    end
  end

  context 'Response with invalid token' do
    before do
      @client = BitlyQuickly.new access_token: 'token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://www.google.com/1') }.to raise_error
    end
  end

  context 'Response with valid token' do
    before do
      @client = BitlyQuickly.new access_token: 'valid_token'
    end

    it 'raises an execption' do
      expect { @client.shorten('http://www.google.com/1') }.to_not raise_error
    end

    it 'status code' do
      expect(@client.shorten('http://www.google.com/1')).to eq('http://pht.io/1eyUhF1')
    end
  end

  context 'Many requests' do
    before do
      @client = BitlyQuickly.new access_token: 'valid_token'
    end

    it 'makes many requests' do
      request_urls = [
        'http://www.google.com/1',
        'http://www.google.com/2',
        'http://www.google.com/3',
        'http://www.google.com/4',
        'http://www.google.com/5',
      ]

      response_urls = [
        'http://pht.io/1eyUhF1',
        'http://pht.io/1eyUhF2',
        'http://pht.io/1eyUhF3',
        'http://pht.io/1eyUhF4',
        'http://pht.io/1eyUhF5',
      ]

      expect(@client.shorten(request_urls)).to eq(response_urls)
    end
  end
end
