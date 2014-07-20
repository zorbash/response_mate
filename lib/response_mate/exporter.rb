module ResponseMate
  class Exporter
    attr_accessor :format, :handler, :manifest, :environment, :resource

    def initialize(args = {})
      @format      = args[:format]
      @manifest    = args[:manifest]
      @environment = args[:environment]
      @resource    = args[:resource]
    end

    def export
      @handler = "ResponseMate::Exporters::#{format.capitalize}".safe_constantize.
        new manifest, environment, resource
      handler.export
    end
  end
end
