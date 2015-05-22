class BitlyQuickly
  # # Error classes.
  # rubocop:disable Style/SpaceAroundOperators
  class Error < StandardError
    class RateLimitExceeded        < Error; end # 403
    class TemporarilyUnavailable   < Error; end # 503
    class NotFound                 < Error; end # 404
    class InvalidRequestOrResponse < Error; end # 500
    class UnknownError             < Error; end # Huh?
  end
end
