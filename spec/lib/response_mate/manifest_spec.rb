require 'spec_helper'

describe ResponseMate::Manifest do
  let(:filename) { 'a_file.yml' }
  let(:file_contents) { ':requests: []' }
  let(:environment) { }

  subject(:manifest) { described_class.new(filename, environment) }

  around do |example|
    File.write filename, file_contents if filename
    quietly { example.run }
    File.delete filename rescue Errno::ENOENT # rubocop:disable Style/RescueModifier
  end

  describe '#filename' do
    subject { manifest.filename }

    context 'when it is present' do
      it 'is assigned to the specified value' do
        is_expected.to eq(filename)
      end
    end

    context 'when it is nil' do
      let(:filename) { nil }

      before { allow_any_instance_of(described_class).to receive(:parse) }

      it 'is assigned to the default value' do
        is_expected.to eq(ResponseMate.configuration.requests_manifest)
      end
    end
  end

  describe '#environment' do
    subject { manifest.environment }

    before { allow(manifest).to receive(:parse) }

    context 'when it is specified' do
      it { is_expected.to eq(environment) }
    end

    context 'when it is not specified' do
      it { is_expected.to be_nil }
    end
  end

  describe '#requests_text' do
    subject { manifest.requests_text }

    context 'when the manifest file exists' do
      let(:file_contents) { ':requests: []' }

      context 'and is not a template' do
        it 'returns the contents of the file' do
          is_expected.to eq(file_contents)
        end
      end

      context 'and is mustache template' do
        let(:file_contents) { ':key: {{var}}' }

        context 'and the environment file exists' do
          let(:template_variable) { { var: 'value' } }
          let(:environment) { double(exists?: true, env: template_variable) }

          it 'returns the processed template' do
            is_expected.to eq(":key: #{template_variable[:var]}")
          end
        end

        context 'and the environment file does not exist' do
          let(:environment) { double(exists?: false, env: {}) }

          it 'returns the contents of the file' do
            is_expected.to eq(':key: ')
          end

          it 'prints a warning to standard error' do
            expect(capture(:stderr) { subject }).to match(/no environment file is found/)
          end
        end
      end
    end

    context 'when the manifest file does not exist' do
      let(:filename) { nil }

      it { expect { subject }.to raise_error(ResponseMate::ManifestMissing) }
    end
  end

  describe '#requests' do
    subject { manifest.requests }

    context 'when the requests text contains requests' do
      let(:file_contents) do
        <<-YAML
        requests:
          -
            key: repos_show
            request:
              path: 'repos/rails/rails'
        YAML
      end

      it 'returns them' do
        expect(subject.map(&:key)).to match_array(%w[repos_show])
      end
    end

    context 'when the requests text does not contain requests' do
      let(:file_contents) { 'missing_requests: true' }

      it 'prints a warning to standard error' do
        expect(capture(:stderr) { subject }).to match(/contains no requests/)
      end

      it 'returns an empty Array' do
        quietly { is_expected.to be_empty }
      end
    end
  end

  describe '#name' do
    let(:name) { 'github apiv3' }
    let(:file_contents) { "name: #{name}" }

    subject { manifest.name }

    it { is_expected.to eq(name) }
  end

  describe '#description' do
    let(:description) { 'a short description of the requests contained in the manifest' }
    let(:file_contents) { "description: #{description}" }

    subject { manifest.description }

    it { is_expected.to eq(description) }
  end

  describe '#requests_for_keys' do
    let(:keys) { }
    subject { manifest.requests_for_keys(keys) }

    context 'when the specified keys are blank' do
      it { is_expected.to eq([]) }
    end

    context 'when a key is missing' do
      let(:keys) { %w[key1 key2] }
      let(:existing_requests) { [keys][1..-1].map { |key| double(key: key) } }

      it 'raises ResponseMate::KeysNotFound' do
        expect { subject }.to raise_error(ResponseMate::KeysNotFound)
      end
    end

    context 'when no key is missing' do
      let(:keys) { %w[key1 key2] }
      let(:existing_requests) { (keys + ['spare_key']).map { |key| double(key: key) } }

      before do
        allow(manifest).to receive(:requests).and_return(existing_requests)
      end

      it 'returns only the requests for the specified keys' do
        expect(subject.map(&:key)).to match_array(keys)
      end
    end
  end
end
