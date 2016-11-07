require 'spec_helper'

RSpec.describe 'Searchworks indexing' do
  subject(:result) { indexer.map_record(record) }

  let(:indexer) { Traject::Indexer.new.tap { |i| i.load_config_file('./indexers/searchworks.rb') } }
  let(:record) { MARC::Reader.new(file_fixture(record_name).to_s).to_a.first }
  let(:record_name) { 'emptyish_record.marc' }

  describe 'id' do
    it 'pulls the value from the 001 field' do
      expect(result).to include 'id' => ["1000165"]
    end
    
    xit 'strips any leading "a" from the value' do
      
    end
  end
end
