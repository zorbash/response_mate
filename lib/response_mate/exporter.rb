# coding: utf-8

module ResponseMate
  class Exporter
    include ResponseMate::ManifestParser

    attr_accessor :format, :handler, :requests_manifest, :manifest

    def initialize(args = {})
      @format = args[:format]
      @requests_manifest = args[:requests_manifest]
    end

    def export
      parse_requests_manifest
      @handler = "ResponseMate::Exporters::#{format.capitalize}".safe_constantize.
        new manifest
      handler.export
    end
  end
end
