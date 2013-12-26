module ResponseMate::Exporters
  class Postman
    include ResponseMate::ManifestParser

    attr_accessor :manifest, :out

    def initialize(manifest)
      @manifest = manifest
      @out = {}
    end

    def export
      build_structure
      build_requests
      out
    end

    private

    def build_structure
      out.merge!({
        id: SecureRandom.uuid,
        name: 'latest_export',
        requests: [],
        order: [],
        timestamp: Time.now.to_i
      })
    end

    def build_requests
      manifest.requests.each do |request|
        req = ResponseMate::Manifest.parse_request(request.request)
        url = if req['params'].present?
                "#{req['path']}?#{req['params'].to_query}"
              else
               req['path']
              end

        out_req = {
          id: SecureRandom.uuid,
          collectionId: out[:id],
          data: [],
          description: '',
          method: req['verb'],
          name: request['key'],
          url: url,
          version: 2,
          responses: [],
          dataMode: 'params',
          headers: request['headers'] || manifest.default_headers
        }

        out[:order] << out_req[:id]
        out[:requests] << out_req
      end
    end
  end
end
