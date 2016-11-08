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

  describe 'pub_search' do
    context 'record with a value in the 260a field' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('260', '0', '1', MARC::Subfield.new('a', 'data'))) } }

      it 'pulls the value from the field' do
        expect(result).to include 'pub_search' => ['data']
      end
    end

    context 'record with a value in the 264a field' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('264', '0', '1', MARC::Subfield.new('a', 'data'))) } }

      it 'pulls the value from the field' do
        expect(result).to include 'pub_search' => ['data']
      end
    end

    context 'record with a value in the 260b field' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('260', '0', '1', MARC::Subfield.new('b', 'data'))) } }

      it 'pulls the value from the field' do
        expect(result).to include 'pub_search' => ['data']
      end
    end

    context 'record with a value in the 264b field' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('264', '0', '1', MARC::Subfield.new('b', 'data'))) } }

      it 'pulls the value from the field' do
        expect(result).to include 'pub_search' => ['data']
      end
    end

    context 'record with a s.l. value' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('260', '0', '1', MARC::Subfield.new('a', 's.L.'))) } }

      it 'pulls the value from the field' do
        expect(result).not_to include 'pub_search'
      end
    end

    context 'record with place of X not identified' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('260', '0', '1', MARC::Subfield.new('a', 'place of publication not IDENTIFIED'))) } }

      it 'pulls the value from the field' do
        expect(result).not_to include 'pub_search'
      end
    end

    context 'record with a s.n. value' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('260', '0', '1', MARC::Subfield.new('b', 's.N.'))) } }

      it 'pulls the value from the field' do
        expect(result).not_to include 'pub_search'
      end
    end

    context 'record with X not identified' do
      let(:record) { MARC::Record.new.tap { |r| r.append(MARC::DataField.new('260', '0', '1', MARC::Subfield.new('b', 'author not IDENTIFIED'))) } }

      it 'pulls the value from the field' do
        expect(result).not_to include 'pub_search'
      end
    end
  end
end
