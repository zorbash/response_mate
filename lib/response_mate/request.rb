# Responsible for keeping all logic related to a
# request defined in the requests manifest
class ResponseMate::Request < OpenStruct
  delegate :[], to: :request

  # Make sure all defined requests in the manifest have complete
  # information for {ResponseMate::Connection#fetch}
  def normalize!
    request[:verb] = begin
      (ResponseMate::HTTP_METHODS & [request.fetch(:verb, 'GET').downcase.to_sym]).first ||
      'GET'
    end

    if request[:url] !~ /{{.*?}}/  # Avoid encoding unprocessed mustache tags
      request[:url] = URI.encode(adjust_scheme(request[:url], request[:scheme]))
    end

    self
  end

  # @return [String] Output string suitable for a terminal
  def to_cli_format
    out = ["[#{key.yellow}] ", request[:verb].to_s.upcase.colorize(:cyan).on_black.bold,
           " #{request[:url]}"].join
    out << "\tparams #{request[:params]}" if request[:params].present?
    out
  end

  # @return [Hash] The Hash representation of the request
  def to_hash
    marshal_dump[:request]
  end

  private

  def adjust_scheme(uri, scheme)
    scheme = %w[http https].include?(scheme) ? scheme : 'http'

    if uri !~ /\Ahttp(s)?/
      "#{scheme}://#{uri}"
    else
      uri
    end
  end
end
