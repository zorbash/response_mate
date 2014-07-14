# coding: utf-8

class ResponseMate::Manifest
  attr_accessor :filename, :requests, :requests_text, :environment
  attr_reader :name, :description

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
    @description = @request_hashes[:description] || ''
    @requests = @request_hashes[:requests].
      map(&:deep_symbolize_keys!).
      map { |rh| ResponseMate::Request.new(rh).normalize! }
  end

  def requests_for_keys(keys)
    if keys.present?
      existing_keys = requests.map(&:key)
      missing_keys = keys - existing_keys

      if missing_keys.present?
        raise ResponseMate::KeysNotFound.new(missing_keys.join(','))
      end

      requests.select! do |r|
        keys.include? r.key
      end
    end
  end
end
