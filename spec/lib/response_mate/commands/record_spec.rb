require 'spec_helper'

describe ResponseMate::Commands::Record do
  include_context 'stubbed_requests'

  describe '#run' do
    context 'with keys option unspecified' do
      before do
        quietly { ResponseMate::Commands::Record.new([], keys: []).run }
      end

      describe 'output files' do
        it 'creates on for each request' do
          expect(output_files.call).to have_exactly(2).items
        end
      end
    end

    context 'with output_dir option specified' do
      let(:other_output_dir) do
        File.expand_path('spec/source/other_output_dir')
      end

      let(:cmd_with_output_dir) do
        quietly do
          ResponseMate::Commands::Record.new([], keys: [],
                                                 output_dir: other_output_dir).run
        end
      end

      context 'when the specified directory exists' do
        let(:output_files) { -> { Dir[other_output_dir + '/*'] } }

        before { cmd_with_output_dir }
        after { output_files.call.each { |file| File.delete(file) } }

        it 'created the tapes in the specified directory' do
          expect(output_files.call).to have_exactly(2).items
        end
      end

      context 'when the specified directory does not exist' do
        let(:other_output_dir) do
          File.expand_path('spec/source/i_do_not_exist')
        end

        it 'raises ResponeMate::OutputDirError' do
          expect { cmd_with_output_dir }.to raise_error(ResponseMate::OutputDirError,
                                                        /#{other_output_dir}/)
        end
      end
    end

    context 'with output_dir option unspecified' do
      it 'creates the tapes in the default output directory' do
        quietly { ResponseMate::Commands::Record.new([], keys: []).run }

        expect(output_files.call).to have_exactly(2).items
      end
    end

    context 'with keys option specified' do
      context 'when the requested key exists' do
        before do
          quietly do
            ResponseMate::Commands::Record.new([], keys: ['user_issues']).run
          end
        end

        it 'creates an output response file' do
          expect(output_files.call).to have_exactly(1).items
        end

        describe 'output response file' do
          let(:output_filename) do
            File.join(ResponseMate.configuration.output_dir, 'user_issues.yml')
          end

          it 'has the right file extension' do
            expect(File.exist?(output_filename)).to be_true
          end

          describe 'YAML content' do
            let(:output_content) { File.read(output_filename) }
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
          ResponseMate::Commands::Record.new([], keys: ['non_existing_key']).run
        end

        it 'raises ResponseMate::KeysNotFound'do
          expect { subject }.to raise_error(ResponseMate::KeysNotFound)
        end
      end
    end
  end
end
