# coding: utf-8
module ResponseMate
  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_accessor :output_dir, :requests_manifest, :oauth_manifest

    def initialize
      @output_dir = './output/responses/'
      @requests_manifest = './requests.yml.erb'
      @oauth_manifest = './oauth.yml'
    end
  end

  def self.setup
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end
