# coding: utf-8

class ResponseMate::Manifest
  include ResponseMate::ManifestParser

  attr_accessor :filename, :requests, :requests_text, :environment, :name

  def initialize(filename, environment = nil)
    @filename = filename || ResponseMate.configuration.requests_manifest
    @environment = environment
    parse
  end

  def preprocess_manifest
    begin
      @requests_text = File.read filename
    rescue Errno::ENOENT
      puts filename.red << ' does not seem to exist'
      exit 1
    end

    if environment.present?
      @requests_text = Mustache.render(@requests_text, environment.try(:env) || {})
    end
  end

  def parse
    preprocess_manifest
    @request_hashes = YAML.load(requests_text).deep_symbolize_keys
    @name = @request_hashes[:name] || filename
    @requests = @request_hashes[:requests].
      map(&:deep_symbolize_keys!).
      map { |rh| ResponseMate::Request.new(rh).normalize! }
  end
end
