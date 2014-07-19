require 'spec_helper'

describe ResponseMate::Commands::List do
  include_context 'stubbed_requests'

  subject { ResponseMate::Commands::List.new([], {}) }
  let(:cmd_output) { capture(:stdout) { subject.run } }

  describe '#run' do
    before { subject.stub(:ask_action).and_return(:no) }

    it 'lists all available keys' do
      expect(cmd_output).to eq("user_issues\nuser_friends\n\n")
    end

    context 'when record is selected' do
      before { subject.stub(:ask_action).and_return(:record) }

      context 'and the 2nd key is selected' do
        before { subject.stub(:ask_key).and_return('user_friends') }

        it 'is recorded' do
          quietly { cmd_output }
          expect(File.basename(output_files.call.last)).to eq('user_friends.yml')
        end
      end
    end

    context 'when inspect is selected' do
      before { subject.stub(:ask_action).and_return(:inspect) }

      context 'and the 2nd key is selected' do
        before { subject.stub(:ask_key).and_return('user_friends') }

        describe 'inspection' do
          it 'contains the response status' do
            expect(cmd_output).to match(/:status/)
          end

          it 'contains the response headers' do
            expect(cmd_output).to match(/:headers/)
          end

          it 'contains the response body' do
            expect(cmd_output).to match(/:body/)
          end
        end
      end
    end
  end
end
