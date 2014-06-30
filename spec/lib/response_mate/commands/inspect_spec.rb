# coding: utf-8

require 'spec_helper'

describe ResponseMate::Commands::Inspect do
  include_context 'stubbed_requests'

  describe '#run' do
    context 'when no keys are specified' do
      it 'displays help message' do
        error_output = nil

        quietly do
          error_output = capture(:stderr) do
            ResponseMate::Commands::Inspect.new([], {}).run
          end
        end

        expect(error_output.strip).to eq("At least one key has to be specified".red)
      end
    end

    context 'when key is specified' do
      let(:mock_request) do
        ResponseMate::Request.new(key: 'user_issues',
                                  request: {
                                    verb: 'GET',
                                    host: 'www.someapi.com',
                                    path: '/user/42/issues' }).normalize!
      end

      let(:captured_output) do
        output = nil

        quietly do
          output = capture(:stdout) do
            ResponseMate::Commands::Inspect.new(['user_issues'], {}).run
          end
        end
        output.strip
      end

      it 'displays the key, host, path, verb of the request' do
        expect(captured_output).to include(mock_request.to_cli_format)
      end

      it 'includes the response status' do
        expect(captured_output).
          to include(":status => #{fake_response_user_issues[:status].to_s}")
      end

      it 'includes the response body' do
        expect(captured_output).to include(%(:body => "#{fake_response_user_issues[:body]}"))
      end

      it 'includes the response headers' do
        expect(captured_output).to include(fake_response_user_issues[:headers].values.last)
      end
    end
  end
end
