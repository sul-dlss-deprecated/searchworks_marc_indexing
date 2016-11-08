require 'spec_helper'

RSpec.describe 'Searchworks indexing' do
  subject(:result) { indexer.map_record(record) }

  let(:indexer) { Traject::Indexer.new.tap { |i| i.load_config_file('./indexers/searchworks.rb') } }
  let(:records) { MARC::Reader.new(file_fixture(fixture_name).to_s).to_a }
  let(:fixture_name) { 'emptyish_record.marc' }
  let(:record) { records.first }

  describe 'id' do
    context 'record with 001 and no subfields' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::ControlField.new('001', '001data'))} }

      it 'pulls the value from the 001 field' do
        expect(result).to include 'id' => ['001data']
      end
    end

    context 'record with 001 subfield "a" data' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::ControlField.new('001', 'asubfieldid'))} }

      it 'strips any leading "a" from the value' do
        expect(result).to include 'id' => ['subfieldid']
      end
    end
  end
end
