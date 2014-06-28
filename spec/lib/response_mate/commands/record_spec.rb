# coding: utf-8

require 'spec_helper'

describe ResponseMate::Commands::Record do
  describe '#run' do
    let(:fake_response) {
      {
        body: 'hello, this is dog',
        status: 200,
        headers: { 'X-Such-Header' => 'very sent' }
      }
    }

    let(:fake_request) {
      {
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v0.8.9'
        }
      }
    }

    before do
      ResponseMate.stub_chain(:configuration, :requests_manifest).
        and_return File.expand_path('spec/source/requests.yml')
      ResponseMate.stub_chain(:configuration, :environment).
        and_return File.expand_path('spec/source/requests.yml')
      ResponseMate.stub_chain(:configuration, :output_dir).
        and_return File.expand_path('spec/source/responses/')
      #FakeWeb.register_uri(:get, 'http://www.example.com/help.html?lang=en',
                           #body: 'hello',
                           #status: 209)
      FakeWeb.register_uri(:get, 'http://www.example.com',
                           body: 'hello',
                           status: 200)
      require 'pry'; binding.pry

      #stub_request(:get, 'http://www.example.com/help.html?lang=en').
        #with(fake_request).
        #to_return(:status => 200, :body => "", :headers => {})
        #to_return(fake_response)
    end

    context 'when the requested key exists' do
      subject do
        ResponseMate::Commands::Record.new([], {}).run
      end

      #before { subject }

      it 'creates an output response file', :focus do
        subject
      end

      describe 'output response file' do
        it 'is valid YAML' do
          pending
        end

        it 'contains the original request verb' do
          pending
        end

        it 'contains the original request path' do
          pending
        end

        it 'contains the original request params' do
          pending
        end

        it 'contains the response status' do
          pending
        end

        it 'includes the response headers' do
          pending
        end

        it 'includes the response body' do
          pending
        end
      end
    end

    context 'when the requested key does not exist' do
      it 'displays an error message' do
        pending
      end
    end
  end
end
