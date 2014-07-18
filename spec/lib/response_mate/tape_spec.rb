# coding: utf-8
require 'spec_helper'

describe ResponseMate::Tape do
  include_context 'stubbed_requests'

  let(:response_headers_hash) do
    { x_powered_by: 'ninjas' }
  end

  let(:response_headers) { double(to_hash: response_headers_hash) }
  let(:response) { double(status: 200, body: 'hello', headers: response_headers) }

  let(:user_issues_request) do
    ResponseMate::Request.new(
      key: 'user_issues',
      request: {
        url: 'www.someapi.com/user/42/issues',
        something_nil: nil
      }).normalize!
  end

  let(:request) { user_issues_request }
  let(:meta) { nil }

  let(:key) { 'some_tape' }

  describe '#write' do
    let(:tape) { YAML.load_file(output_files.call.last) }

    let(:output_dir) { nil }

    let(:write) do
      ResponseMate::Tape.new.write(key, request, response, meta, output_dir)
    end

    subject { write }

    it 'creates a new tape with key parameter as the filename' do
      subject
      expect(File.basename(output_files.call.last)).to eq("#{key}.yml")
    end

    describe 'tape location' do
      context 'when the specified output_dir exists' do
        let(:output_dir) { File.expand_path('./spec/source/other_output_dir') }
        let(:output_files) { ->{ Dir[output_dir + '/*'] } }

        after { output_files.call.each { |file| File.delete(file) } }

        it 'is inside the specified output_dir' do
          subject
          expect(tape).to be
        end
      end

      context 'when the specified output_dir does not exist' do
        let(:output_dir) do
          File.expand_path('spec/source/i_do_not_exist')
        end

        it 'raises ResponeMate::OutputDirError' do
          expect { subject }.to raise_error(ResponseMate::OutputDirError)
        end
      end
    end

    describe 'the created tape' do
      before { write }
      subject { tape }

      it 'is valid YAML' do
        subject
      end

      describe 'the request' do
        subject { tape[:request] }

        it 'exists' do
          expect(subject).to be
        end

        it 'does not have any nil values' do
          expect(subject).to_not have_key(:something_nil)
        end
      end

      describe 'the response' do
        subject { tape[:response] }

        it 'exists' do
          expect(subject).to be
        end

        it 'contains status' do
          expect(subject).to have_key(:status)
        end

        it 'contains headers' do
          expect(subject).to have_key(:headers)
        end

        describe 'headers' do
          subject { tape[:response][:headers] }

          it { expect(subject).to be_a(Hash) }
        end

        it 'contains body' do
          expect(subject).to have_key(:body)
        end
      end

      it 'contains a created_at timestamp' do
        expect(subject).to have_key(:created_at)
      end

      context 'when meta is supplied' do
        let(:meta) { 'some meta info' }

        it 'contains meta' do
          expect(subject).to have_key(:meta)
        end
      end

      context 'when meta is not supplied' do
        it 'does not contain meta' do
          expect(subject).to_not have_key(:meta)
        end
      end
    end
  end

  describe '.load' do
    subject { ResponseMate::Tape.load(key) }

    context 'when a tape for the given key exists' do
      before do
        ResponseMate::Tape.new.write(key, request, response, meta)
      end

      it 'returns valid YAML' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when tape for the given key does not exist' do
      let(:key) { 'nonexistent_key' }

      it 'raises an error' do
        expect { subject }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
