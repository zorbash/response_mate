require 'spec_helper'

describe ResponseMate::ManifestParser, fakefs: true do
  let(:subject) do
    Class.new {
      include ResponseMate::ManifestParser
      attr_reader :requests_manifest

      def initialize
        @requests_manifest = 'foo.yml'
      end
    }.new
  end

  describe '#preprocess_manifest' do
    context 'when the manifest file exists' do
      before do
        File.open('foo.yml', 'w') do |f|
          f.puts('base_url: http://koko.com')
        end
      end

      it 'sets @requests text to a string' do
      end
    end

    context 'when the manifest file does not exist' do
      it 'exits with status 1' do
        expect { subject.preprocess_manifest }.to raise_error SystemExit
      end
    end
  end
end
