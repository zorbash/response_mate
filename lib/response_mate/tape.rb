# coding: utf-8

class ResponseMate::Tape
  def write(key, request, response, meta = {})
    File.open("#{ResponseMate.configuration.output_dir}#{key}.yml", 'w') do |f|
      file_content = {
        request: request.select { |_, v| !v.nil? },
        status: response.status,
        headers: response.headers.to_hash,
        body: response.body
      }

      file_content.merge!(meta: meta) if meta.present?

      f << file_content.to_yaml
    end
  rescue Errno::ENOENT
    raise ResponseMate::OutputDirError
  end
end
