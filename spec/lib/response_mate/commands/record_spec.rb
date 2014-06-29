# coding: utf-8

require 'spec_helper'

describe ResponseMate::Commands::Record do
  include_context 'stubbed_requests'

  describe '#run' do
    context 'with keys option unspecified' do
      before do
        ResponseMate::Commands::Record.new([], {}).run
      end

      describe 'output files' do
        it 'creates on for each request' do
          expect(output_files.call).to have_exactly(2).items
        end
      end
    end

    context 'with keys option specified' do
      context 'when the requested key exists' do
        before do
          ResponseMate::Commands::Record.new([], { keys: ['user_issues'] }).run
        end

        it 'creates an output response file', focus: true do
          expect(output_files.call).to have_exactly(1).items
        end

        describe 'output response file' do
          let(:output_filename) do
            File.join(ResponseMate.configuration.output_dir, 'user_issues.yml')
          end

          it 'has the right file extension' do
            expect(File.exists?(output_filename)).to be_true
          end

          describe 'YAML content' do
            let(:output_content) do
              File.read(output_filename)
            end

            subject { YAML.load(output_content) }

            it 'is valid' do
              expect { subject }.to_not raise_error
            end

            it 'contains the original request verb' do
              expect(subject[:request][:verb]).to be_present
            end

            it 'contains the original request path' do
              pending
            end

            it 'contains the original request params' do
              pending
            end

            it 'contains the response status' do
              expect(subject[:response][:status]).
                to eql(fake_response_user_issues[:status])
            end

            it 'includes the response headers' do
              expect(subject[:response][:headers]).
                to eql(fake_response_user_issues[:headers])
            end

            it 'includes the response body' do
              expect(subject[:response][:body]).
                to eql(fake_response_user_issues[:body])
            end
          end
        end
      end

      context 'when the requested key does not exist' do
        subject do
          ResponseMate::Commands::Record.new([], {
            keys: ['non_existing_key']
          }).run
        end

        it 'raises ResponseMate::KeysNotFound'do
          expect { subject }.to raise_error(ResponseMate::KeysNotFound)
        end
      end
    end
  end
end
