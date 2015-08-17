require 'spec_helper'

describe ResponseMate::Commands::List do
  include_context 'stubbed_requests'

  let(:options) { {} }
  let(:cmd_output) { capture(:stdout) { subject.run } }

  subject(:command) { ResponseMate::Commands::List.new([], options) }

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

        describe 'output directory' do
          context 'when the output_dir option is specified' do
            let(:custom_output_dir) do
              File.expand_path('spec/source/other_output_dir')
            end

            let(:options) { { output_dir: custom_output_dir } }

            context 'and it exists' do
              let(:output_files) { -> { Dir[custom_output_dir + '/*'] } }

              after { output_files.call.each { |file| File.delete(file) } }

              it 'places the tapes in the specified directory' do
                quietly { command.run }

                expect(output_files.call.size).to eq(1)
              end
            end

            context 'and it does not exist' do
              let(:custom_output_dir) do
                File.expand_path('spec/source/i_do_not_exist')
              end

              it 'raises ResponeMate::OutputDirError' do
                expect { quietly { command.run } }.to raise_error(ResponseMate::OutputDirError,
                                                      /#{custom_output_dir}/)
              end
            end
          end

          context 'when the output_dir options is not specified' do
            it 'places the tapes in the default output directory' do
              quietly { command.run }

              expect(output_files.call.size).to eq(1)
            end
          end
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
