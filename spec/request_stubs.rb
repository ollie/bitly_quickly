1.upto(5) do |n|
  WebMock
    .stub_request(
      :get,
      'https://api-ssl.bitly.com/v3/shorten?access_token=valid_token' \
      "&longUrl=http://example.org/200/#{n}"
    )
    .to_return(
      status: 200,
      body: %({
        "status_code": 200,
        "status_txt":  "OK",
        "data": {
          "long_url":    "http:\/\/example.org\/200\/#{n}",
          "url":         "http:\/\/pht.io\/1eyUhF#{n}",
          "hash":        "1eyUhFo",
          "global_hash": "2V6CFi",
          "new_hash":    0
        }
      })
    )
end

WebMock
  .stub_request(
    :get,
    'https://api-ssl.bitly.com/v3/shorten?access_token=token' \
    '&longUrl=http://example.org/403'
  )
  .to_return(
    status: 200,
    body: '{
      "data":        null,
      "status_code": 403,
      "status_txt":  "RATE_LIMIT_EXCEEDED"
    }'
  )

WebMock
  .stub_request(
    :get,
    'https://api-ssl.bitly.com/v3/shorten?access_token=token' \
    '&longUrl=http://example.org/404'
  )
  .to_return(
    status: 200,
    body: '{
      "data":        null,
      "status_code": 404,
      "status_txt":  "NOT_FOUND"
    }'
  )

WebMock
  .stub_request(
    :get,
    'https://api-ssl.bitly.com/v3/shorten?access_token=toke' \
    'n&longUrl=http://example.org/500'
  )
  .to_return(
    status: 200,
    body: '{
      "data":        null,
      "status_code": 500,
      "status_txt":  "INVALID_URI"
    }'
  )

WebMock
  .stub_request(
    :get,
    'https://api-ssl.bitly.com/v3/shorten?access_token=token' \
    '&longUrl=http://example.org/503'
  )
  .to_return(
    status: 200,
    body: '{
      "data":        null,
      "status_code": 503,
      "status_txt":  "UNKNOWN_ERROR"
    }'
  )

WebMock
  .stub_request(
    :get,
    'https://api-ssl.bitly.com/v3/shorten?access_token=token' \
    '&longUrl=http://example.org/666'
  )
  .to_return(
    status: 200,
    body: '{
      "data":        null,
      "status_code": 666,
      "status_txt":  "WHO_KNOWS"
    }'
  )
