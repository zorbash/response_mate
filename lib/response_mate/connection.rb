# coding: utf-8

# This class provides a layer above the HTTP client
class ResponseMate::Connection
  delegate :params, to: :client
  delegate(*(ResponseMate::ManifestParser::HTTP_VERBS), to: :client)

  attr_accessor :client

  def initialize
    @client = Faraday.new do |c|
      c.use FaradayMiddleware::FollowRedirects, limit: 5
      c.adapter Faraday.default_adapter
    end
  end

  def fetch(request)
    main_uri = if request[:url]
                 request[:url]
               elsif request[:host]
                 request[:host]
               end

    adjusted_uri = adjust_scheme(main_uri, request[:scheme])
    uri = URI.parse(adjusted_uri)
    uri.path  = adjust_path(request[:path]) if request[:path]
    uri.query = request[:params].to_query if request[:params]
    verb = request[:verb] || 'GET'

    client.send verb.downcase.to_sym, uri.to_s
  rescue Faraday::Error::ConnectionFailed
    puts "Is a server up and running at #{request[:path]}?".red
    exit 1
  end

  def adjust_scheme(uri, scheme)
    scheme = %w[http https].include?(scheme) ? scheme : 'http'

    if uri !~ /\Ahttp(s)?/
      "#{scheme}://#{uri}"
    else
      uri
    end
  end

  def adjust_path(path)
    if path !~ %r{\A/}
      "/#{path}"
    else
      path
    end
  end
end
