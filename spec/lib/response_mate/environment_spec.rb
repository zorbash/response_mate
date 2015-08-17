require 'spec_helper'

describe ResponseMate::Environment do
  let(:filename) { 'a_file.yml' }

  subject(:environment) { described_class.new(filename) }

  describe '#exists?' do
    subject { environment.exists? }

    context 'when the file with filename exists' do
      around do |example|
        File.write filename, ''
        example.run
        File.delete filename
      end

      it { is_expected.to be(true) }
    end

    context 'when the file with filename exists does not exist' do
      it { is_expected.to be(false) }
    end
  end
end
