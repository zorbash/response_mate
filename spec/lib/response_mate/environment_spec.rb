require 'spec_helper'

describe ResponseMate::Environment do
  let(:filename) { 'a_file.yml' }

  subject(:environment) { described_class.new(filename) }

  describe 'initialization' do
    describe 'filename' do
      subject { environment.filename }

      context 'when it is present' do
        it 'is assigned to the specified value' do
          is_expected.to eq(filename)
        end
      end

      context 'when it is nil' do
        let(:filename) { nil }

        it 'is assigned to the default value' do
          is_expected.to eq(ResponseMate.configuration.environment)
        end
      end
    end

    describe '#env' do
      subject { environment.env }

      context 'when the file exists' do
        around do |example|
          File.open(filename, 'w') { |f| f << ':foo: bar' }
          example.run
          File.delete(filename)
        end

        it 'is assigned to the parsed YAML file' do
          is_expected.to eq(foo: 'bar')
        end
      end

      context 'when the file does not exist' do
        it 'is assigned to an empty Hash' do
          is_expected.to eq({})
        end
      end
    end
  end

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

    context 'when the file with filename does not exist' do
      it { is_expected.to be(false) }
    end
  end
end
