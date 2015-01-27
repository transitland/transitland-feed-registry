require_relative '../../../lib/onestop_id_registry/comparison_sources/gtfs_data_exchange'

describe OnestopIdRegistry::ComparisonSources::GtfsDataExchange do
  before(:each) do
    @tempfile = Tempfile.new(['gtfs_data_exchange', '.json'])
    stub_const('OnestopIdRegistry::ComparisonSources::GtfsDataExchange::LOCAL_PATH', @tempfile.path)
    VCR.use_cassette("gtfs_data_exchange") do
      OnestopIdRegistry::ComparisonSources::GtfsDataExchange.fetch_and_post_process
    end
  end

  after(:each) do
    @tempfile.close
    @tempfile.unlink
  end

  it 'should be able to fetch the agency JSON file' do
    parsed_json = JSON.parse(@tempfile.read)
    expect(parsed_json.count).to eq 846
  end

  it 'should be able to expose feeds as a parsed list' do
    expect(OnestopIdRegistry::ComparisonSources::GtfsDataExchange.feeds.length).to eq 846
  end

  it 'can be compared against Onestop IDs for feeds' do
    all_comparisons = OnestopIdRegistry::ComparisonSources::GtfsDataExchange.compare_against_onestop_feeds
    bart = all_comparisons.find { |comparison| comparison[:onestop_id] == 'f-9q9-BART' }
    expect(bart[:gtfs_data_exchange_feed][:dataexchange_id]).to eq 'bay-area-rapid-transit'
  end
end
