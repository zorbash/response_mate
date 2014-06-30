require 'spec_helper'

shared_context 'stubbed_requests' do
  let(:fake_response_user_issues) {
    {
      headers: { 'x-issue-format' => 'tps report' },
      body: 'This user definitely has issues',
      status: 418
    }
  }

  let(:fake_response_user_friends) {
    {
      body: "User has friends",
      status: 418
    }
  }

  let(:output_files) do
    ->{ Dir[ResponseMate.configuration.output_dir + '/*'] }
  end

  before do
    ResponseMate.stub_chain(:configuration, :requests_manifest).
      and_return File.expand_path('spec/source/requests.yml')
    ResponseMate.stub_chain(:configuration, :environment).
      and_return File.expand_path('spec/source/environment.yml')
    ResponseMate.stub_chain(:configuration, :output_dir).
      and_return File.expand_path('spec/source/responses/')

    FakeWeb.register_uri(:get, 'http://www.someapi.com/user/42/issues', {
                           status: fake_response_user_issues[:status],
                           body: fake_response_user_issues[:body],
                         }.merge(fake_response_user_issues[:headers]))

    FakeWeb.register_uri(:get, 'http://www.someapi.com/user/42/friends',
                           status: fake_response_user_friends[:status],
                           body: fake_response_user_friends[:body])
  end

  before(:each) do
    output_files.call.each { |file| File.delete(file) }
  end
end
