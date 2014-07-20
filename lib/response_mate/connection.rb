# This class provides a layer above the HTTP client
class ResponseMate::Connection
  delegate :params, to: :client
  delegate(*(ResponseMate::HTTP_METHODS), to: :client)

  attr_accessor :client

  def initialize
    @client = Faraday.new do |c|
      c.use FaradayMiddleware::FollowRedirects, limit: 5
      c.adapter Faraday.default_adapter
    end
  end

  # Performs the supplied request
  # @param {ResponseMate::Request} The request to be performed
  def fetch(request)
    uri = URI.parse(request[:url])

    if request[:params]
      query = request[:params].to_query
      query = uri.query ? uri.query << '&' << query : query
      uri.query = query
    end

    verb = request[:verb] || 'GET'

    client.headers = request[:headers] if request[:headers]
    client.send verb.downcase.to_sym, uri.to_s
  rescue Faraday::Error::ConnectionFailed
    puts "Is a server up and running at #{request[:path]}?".red
    exit 1
  end
end
