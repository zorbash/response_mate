# coding: utf-8

require 'spec_helper'

describe ResponseMate::Configuration do
  describe '.initialize' do
    let(:subject) { ResponseMate::Configuration.new }

    it 'assigns @output_dir' do
      expect(subject.output_dir).to be_present
    end

    it 'assigns @requests_manifest' do
      expect(subject.requests_manifest).to be_present
    end

    it 'assigns @oauth_manifest' do
      expect(subject.oauth_manifest).to be_present
    end
  end
end

describe ResponseMate do
  describe '.setup' do
    context '@configuration is nil' do
      before { ResponseMate.configuration = nil }

      it 'assigns @configuration to a new ResponseMate::Configuration' do
        expect(ResponseMate::Configuration).to receive(:new)
        ResponseMate.setup
      end
    end

    context '@configuration is not nil' do
      before { ResponseMate.configuration = ResponseMate::Configuration.new }

      it 'does not assign @configuration to a new ResponseMate::Configuration' do
        ResponseMate::Configuration.should_not_receive(:new)
        ResponseMate.setup
      end
    end

    describe 'configuration block' do
      before do
        ResponseMate.setup do |config|
          config.output_dir        = 'foo'
          config.requests_manifest = 'bar'
          config.oauth_manifest    = 'koko'
        end
      end

      after do
        ResponseMate.setup do |config|
          config.output_dir        = './output/responses/'
          config.requests_manifest = './requests.yml.erb'
          config.oauth_manifest    = './oauth.yml'
        end
      end

      it 'properly assigns ivars' do
        expect(ResponseMate.configuration.output_dir).to eq('foo')
        expect(ResponseMate.configuration.requests_manifest).to eq('bar')
        expect(ResponseMate.configuration.oauth_manifest).to eq('koko')
      end
    end
  end
end
