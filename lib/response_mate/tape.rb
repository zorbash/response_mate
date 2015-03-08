# Responsible for the recorded responses as files
class ResponseMate::Tape
  # Writes the tape as a file
  def write(key, request, response, meta = {}, output_dir = nil)
    output_dir ||= ResponseMate.configuration.output_dir

    output_path = File.join output_dir, "#{key}.yml"

    File.open(output_path, 'w') do |f|
      file_content = {
        request: request.to_hash.select { |_, v| !v.nil? },
        response: {
          status: response.status,
          headers: _utf8_encode(response.headers.to_hash),
          body: _utf8_encode(response.body)
        },
        created_at: Time.now
      }

      file_content.merge!(meta: meta) if meta.present?

      f << file_content.to_yaml
    end
  rescue Errno::ENOENT
    raise ResponseMate::OutputDirError.new(output_dir)
  end

  private

  def _utf8_encode(object)
    case object
    when String
      object.force_encoding('UTF-8')
    when Hash
      object.each do |k, v| # rubocop:disable Lint/UnusedBlockArgument
        k = _utf8_encode(v) # rubocop:disable Lint/UselessAssignment
        v = _utf8_encode(v) # rubocop:disable Lint/UselessAssignment
      end
    when Array
      object.each { |v| _utf8_encode(v) }
    end
  end

  class << self
    def load(key)
      YAML.load_file(File.join(ResponseMate.configuration.output_dir, "#{key}.yml")).
        symbolize_keys
    end
  end
end
