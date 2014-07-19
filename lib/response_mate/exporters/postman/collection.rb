class ResponseMate::Exporters::Postman
  # Handles exporting to postman format
  # Example output
  # https://www.getpostman.com/collections/dbc0521911e45471ff4a
  class Collection
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
      out.merge!(
        id: SecureRandom.uuid,
        name: manifest.name,
        description: manifest.description,
        requests: [],
        order: [],
        timestamp: Time.now.to_i
      )
    end

    def build_requests
      manifest.requests.each do |request|
        out_req = build_request(request)

        out[:order] << out_req[:id]
        out[:requests] << out_req
      end
    end

    def build_request(request)
      {
        id: SecureRandom.uuid,
        collectionId: out[:id],
        data: [],
        description: '',
        method: request[:verb],
        name: request.key,
        url: request[:url],
        version: 2,
        responses: [],
        dataMode: 'params',
        headers: request[:headers].map { |k, v| "#{k}: #{v}" }.join("\n")
      }
    end
  end
end
