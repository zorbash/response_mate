module ResponseMate::ManifestParser
  HTTP_VERBS = %w(GET POST PUT PATCH DELETE HEAD OPTIONS)
  REQUEST_MATCHER = /^(?<verb>(#{HTTP_VERBS.join('|')})) (?<path>(.)*)$/im
  DEFAULT_REQUEST = {
    verb: 'GET'
  }
end
