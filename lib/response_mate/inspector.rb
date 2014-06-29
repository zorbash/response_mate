# coding: utf-8

class ResponseMate::Inspector
  attr_accessor :conn, :manifest

  def initialize(args = {})
    @manifest = args[:manifest]

    @conn = ResponseMate::Connection.new
  end

  def inspect_key(key, options = {})
    request = manifest.requests.find { |r| r.key == key }
    request = ResponseMate::Manifest.parse_request(request.request)

    puts "[#{key}] #{request[:verb]}".cyan_on_black.bold <<  " #{request[:path]}"
    puts "\tparams #{request[:params]}" if request[:params].present?

    print_pretty(conn.fetch(request))
  end

  def inspect_interactive(input)
    request = ResponseMate::Manifest.parse_request(input)
    print(conn.fetch(request))
  end

  def print_pretty(response)
    ap(status: response.status,
       headers: response.headers,
       body: response.body)
  end
end
