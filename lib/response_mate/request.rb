class ResponseMate::Request < OpenStruct
  delegate :[], to: :request

  def normalize!
    unless ResponseMate::HTTP_METHODS.include? request[:verb]
      request[:verb] = 'GET'
    end

    request[:url] = URI.encode(adjust_scheme(request[:url], request[:scheme]))

    self
  end

  def to_cli_format
    out = "[#{key}] #{request[:verb]}".cyan_on_black.bold << " #{request[:url]}"
    out << "\tparams #{request[:params]}" if request[:params].present?
    out
  end

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
