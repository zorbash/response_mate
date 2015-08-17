require 'spec_helper'

describe ResponseMate::Recorder do
  include_context 'stubbed_requests'

  let(:user_issues_request) do
    ResponseMate::Request.new(
      key: 'user_issues',
      request: {
        url: 'www.someapi.com/user/42/issues'
      }).normalize!
  end

  let(:user_friends_request) do
    ResponseMate::Request.new(
      key: 'user_friends',
      request: {
        url: 'www.someapi.com/user/42/friends',
        params: {
          trusty: 'yes',
          since: 'childhood'
        }
      }).normalize!
  end

  let(:requests) { [user_issues_request, user_friends_request] }
  let(:manifest) { double(requests: requests) }

  describe '.initialize' do
    context 'when initialization option :manifest is present' do
      let(:subject) { ResponseMate::Recorder.new(manifest: manifest) }

      it 'assigns manifest to that argument' do
        expect(subject.manifest).to eq(manifest)
      end
    end

    it 'creates a new instance of ResponseMate::Connection' do
      expect(subject.conn).to be_a(ResponseMate::Connection)
    end
  end

  describe '#record' do
    let(:subject) { ResponseMate::Recorder.new(manifest: manifest) }

    before do
      allow(manifest).to receive(:requests_for_keys).and_return([user_issues_request])
    end

    context 'with a single key specified' do
      it 'only records this key' do
        subject.should_receive(:process).with(user_issues_request)
        subject.record('user_issues')
      end
    end

    context 'with no keys specified' do
      it 'records all keys in the manifest' do
        quietly { subject.record([]) }
        expect(output_files.call.size).to eq(2)
      end
    end
  end

  describe '#process' do
    let(:subject) { ResponseMate::Recorder.new(manifest: manifest) }

    it 'writes a new ResponseMate::Tape for the specified request' do
      ResponseMate::Tape.any_instance.should_receive(:write)
      quietly { subject.send :process, user_issues_request }
    end
  end
end
