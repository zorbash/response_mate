# coding: utf-8

class ResponseMate::Tape
  def write(key, request, response, meta = {})
    output_dir = ResponseMate.configuration.output_dir
    output_path = File.join output_dir, "#{key}.yml"

    File.open(output_path, 'w') do |f|
      file_content = {
        request: request.select { |_, v| !v.nil? },
        response: {
          status: response.status,
          headers: response.headers,
          body: response.body
        }
      }

      file_content.merge!(meta: meta) if meta.present?

      f << file_content.to_yaml(canonical: true)
    end
  rescue Errno::ENOENT
    raise ResponseMate::OutputDirError
  end
end
