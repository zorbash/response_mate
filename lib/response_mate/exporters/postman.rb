# coding: utf-8

module ResponseMate::Exporters
  # Handles exporting to postman format
  # Example output
  # https://www.getpostman.com/collections/dbc0521911e45471ff4a
  class Postman
    include ResponseMate::ManifestParser

    attr_accessor :manifest, :environment, :resource, :out

    def initialize(manifest, environment, resource)
      @manifest    = manifest
      @environment = environment
      @resource    = resource
      @out = {}
    end

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
