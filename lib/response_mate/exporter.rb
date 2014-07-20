module ResponseMate
  # Responsible for exporting response_mate manifest to
  # formats understood by other similar tools
  class Exporter
    attr_accessor :format, :handler, :manifest, :environment, :resource

    def initialize(args = {})
      @format      = args[:format]
      @manifest    = args[:manifest]
      @environment = args[:environment]
      @resource    = args[:resource]
    end

    # Returns the compatible transformed resource
    def export
      @handler = "ResponseMate::Exporters::#{format.capitalize}".safe_constantize.
        new manifest, environment, resource
      handler.export
    end
  end
end
