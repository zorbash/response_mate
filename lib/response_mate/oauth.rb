# coding: utf-8

module ResponseMate
  class Oauth
    attr_accessor :manifest

    def initialize
      @manifest = YAML.load_file(ResponseMate.configuration.oauth_manifest)
    rescue Errno::ENOENT
      @manifest = nil
    end

    def token
      manifest['token']
    end
  end
end
