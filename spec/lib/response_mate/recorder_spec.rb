# coding: utf-8
require 'spec_helper'

# TODO: This spec needs some love
describe ResponseMate::Recorder, fakefs: true do
  pending '.initialize' do
    let(:subject) { ResponseMate::Recorder.new }

    context 'args[:requests_manifest] is present' do
      let(:subject) { ResponseMate::Recorder.new(requests_manifest: 'lala.yml') }

      it 'assigns @requests_manifest to that argument' do
        expect(subject.requests_manifest).to eq('lala.yml')
      end
    end

    pending 'args[:requests_manifest] is not present' do
      let(:subject) { ResponseMate::Recorder.new }

      it 'assigns @requests_manifest to ResponseMate.configuration.requests_manifest' do
        expect(subject.requests_manifest).
          to eq(ResponseMate.configuration.requests_manifest)
      end
    end

    context 'args[:base_url] is present' do
      let(:subject) { ResponseMate::Recorder.new(base_url: 'http://example.com') }

      it 'assigns @base_url to that argument' do
        expect(subject.base_url).to eq('http://example.com')
      end
    end

    context 'args[:base_url] is not present' do
      it 'assigns @base_url to the one found in the manifest' do
        expect(subject.base_url).to eq('http://koko.com')
      end
    end

    it 'calls #parse_requests_manifest' do
      ResponseMate::Recorder.any_instance.should_receive :parse_requests_manifest
      subject
    end

    it 'calls #initialize_connection' do
      ResponseMate::Recorder.any_instance.should_receive :initialize_connection
      subject
    end
  end

  pending '#record', fakefs: false do
    before do
      FakeFS.deactivate!
      FileUtils.cp 'spec/fixtures/two_keys.yml.erb', 'two_keys.yml.erb'
      ResponseMate::Oauth.any_instance.stub(:token).and_return 'some_token'
    end

    after do
      FileUtils.rm ['two_keys.yml.erb'] + Dir.glob('output/responses/*.yml')
    end

    let(:subject) { ResponseMate::Recorder.new(requests_manifest: 'two_keys.yml.erb') }

    describe 'output file' do
      before do
        subject.stub(:fetch).and_return(double(status: 200, headers: 'koko', body: 'foo'))
        subject.record
      end

      let(:response) { YAML::load_file 'output/responses/one.yml' }

      it 'is named after the recording key and ends in .yml' do
        expect(Dir.glob('output/responses/*.yml').map { |f| File.basename f }).
          to eq(%w(one.yml two.yml))
      end

      it 'contains response status' do
        expect(response[:status]).to eq(200)
      end

      it 'contains response headers' do
        expect(response[:headers]).to eq('koko')
      end

      it 'contains response body' do
        expect(response[:body]).to eq('foo')
      end

      describe 'request' do
        it 'contains verb' do
          expect(response[:request][:verb]).to be_present
        end

        it 'contains path' do
          expect(response[:request][:path]).to be_present
        end

        it 'contains params' do
          expect(response[:request][:params]).to be_present
        end
      end
    end
  end
end
