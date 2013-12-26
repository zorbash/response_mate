# coding: utf-8

module ResponseMate
  class Exporter
    attr_accessor :format, :handler, :manifest

    def initialize(args = {})
      @format = args[:format]
      @manifest = args[:manifest]
    end

    def export
      @handler = "ResponseMate::Exporters::#{format.capitalize}".safe_constantize.
        new manifest
      handler.export
    end
  end
end
