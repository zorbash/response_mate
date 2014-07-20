module ResponseMate::Exporters
  # Handles exporting to postman format
  # Example output
  # https://www.getpostman.com/collections/dbc0521911e45471ff4a
  class Postman
    autoload :Collection, 'response_mate/exporters/postman/collection'
    autoload :Environment, 'response_mate/exporters/postman/environment'

    attr_accessor :manifest, :environment, :resource, :out

    # @param {ResponseMate::Manifest} The requests manifest
    # @param {ResponseMate::Manifest} The requests manifest
    # @return {Response::Mate::Exporters::Postman}
    def initialize(manifest, environment, resource)
      @manifest    = manifest
      @environment = environment
      @resource    = resource
      @out = {}
    end

    # Performs the export operation
    # @return [Hash] The transformed resource
    def export
      case resource
      when 'manifest'
        ResponseMate::Exporters::Postman::Collection.new(manifest).export
      when 'environment'
        ResponseMate::Exporters::Postman::Environment.new(environment).export
      else
        fail 'Unsupported resource'
      end
    end
  end
end
