require 'spec_helper'

describe ResponseMate::Configuration do
  subject(:configuration) { ResponseMate::Configuration.new }

  describe '.initialize' do
    describe 'output_dir' do
      subject { configuration.output_dir }

      it 'has ./ as the default value' do
        is_expected.to eq('./')
      end
    end

    it 'assigns @requests_manifest' do
      expect(subject.requests_manifest).to be_present
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
        end
      end

      it 'properly assigns ivars' do
        expect(ResponseMate.configuration.output_dir).to eq('foo')
        expect(ResponseMate.configuration.requests_manifest).to eq('bar')
      end
    end
  end
end
