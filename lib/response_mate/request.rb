# coding: utf-8

class ResponseMate::Request < OpenStruct
  delegate :[], to: :request

  def normalize!
    unless ResponseMate::ManifestParser::HTTP_VERBS.include? self.request[:verb]
      self.request[:verb] = 'GET'
    end

    self
  end

  def to_cli_format
    out = "[#{key}] #{request[:verb]}".cyan_on_black.bold <<
          " #{request[:host]}#{request[:path]}"
    out << "\tparams #{request[:params]}" if request[:params].present?
    out
  end
end
