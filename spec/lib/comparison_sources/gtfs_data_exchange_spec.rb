require_relative '../../../lib/onestop_id_registry/comparison_sources/gtfs_data_exchange'

describe OnestopIdRegistry::ComparisonSources::GtfsDataExchange do
  before(:each) do
    @tempfile = Tempfile.new(['gtfs_data_exchange', '.json'])
    stub_const('OnestopIdRegistry::ComparisonSources::GtfsDataExchange::LOCAL_PATH', @tempfile.path)
    VCR.use_cassette("gtfs_data_exchange") do
      OnestopIdRegistry::ComparisonSources::GtfsDataExchange.fetch
    end
  end

  after(:each) do
    @tempfile.close
    @tempfile.unlink
  end

  it 'should be able to fetch the agency JSON file' do
    OnestopIdRegistry::ComparisonSources::GtfsDataExchange.post_process
    parsed_json = JSON.parse(@tempfile.read)
    expect(parsed_json.count).to eq 846
  end
end
