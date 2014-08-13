require 'spec_helper'

describe ResponseMate::Exporters::Postman::Collection do
  include_context 'stubbed_requests'

  let(:manifest) do
    ResponseMate::Manifest.new(ResponseMate.configuration.requests_manifest)
  end

  describe '#export' do
    let(:collection) do
      ResponseMate::Exporters::
        Postman::Collection.new(manifest)
    end

    let(:exported) { collection.export }

    subject { exported }

    it 'is can be valid JSON' do
      expect { subject.to_json }.to_not raise_error
    end

    it 'contains id' do
      expect(subject).to have_key :id
    end

    it 'contains name' do
      expect(subject).to have_key :name
    end

    it 'contains description' do
      expect(subject).to have_key :description
    end

    it 'contains order' do
      expect(subject).to have_key :order
    end

    describe 'order' do
      it { expect(subject[:order]).to be_an(Array) }
    end

    it 'contains timestamp' do
      expect(subject).to have_key :order
    end

    describe 'requests' do
      subject { exported[:requests].first }

      it 'contains id' do
        expect(subject).to have_key(:id)
      end

      it 'contains collectionId' do
        expect(subject[:collectionId]).to eq(exported[:id])
      end

      it 'contains data' do
        expect(subject).to have_key(:data)
      end

      describe 'data' do
        it 'is an Array' do
          expect(subject[:data]).to be_an(Array)
        end
      end

      it 'contains description' do
        expect(subject).to have_key(:description)
      end

      it 'contains method' do
        expect(subject).to have_key(:method)
      end

      it 'contains name' do
        expect(subject).to have_key(:name)
      end

      it 'contains url' do
        expect(subject).to have_key(:url)
      end

      it 'contains version' do
        expect(subject[:version]).to eq(2)
      end

      it 'contains responses' do
        expect(subject).to have_key(:responses)
      end

      describe 'responses' do
        it { expect(subject[:responses]).to be_an(Array) }
      end

      it 'contains dataMode' do
        expect(subject).to have_key(:responses)
      end

      it 'contains headers' do
        expect(subject).to have_key(:headers)
      end

      describe 'headers' do
        it { expect(subject[:headers]).to be_a(String) }
      end
    end

    context 'when the manifest contains mustache tags' do
      before do
        ResponseMate.stub_chain(:configuration, :requests_manifest).
          and_return File.expand_path('spec/source/requests_mustache.yml')
      end

      describe 'requests' do
        subject { exported[:requests].last }

        it 'have mustache unprocessed' do
          expect(subject[:url]).to match(/{{.*?}}/)
        end
      end
    end
  end
end
