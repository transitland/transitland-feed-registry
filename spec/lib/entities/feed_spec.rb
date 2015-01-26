require_relative '../../../lib/onestop_registry/entities/feed'

describe OnestopRegistry::Entities::Feed do
  context 'all' do
  end

  context 'individual' do
    it 'can be initialized from a JSON file, by providing the appropriate Onestop ID' do
      feed = OnestopRegistry::Entities::Feed.new(onestop_id: 'f-9q9-BART')
      expect(feed.onestop_id).to eq 'f-9q9-BART'
      expect(feed.feed_format).to eq 'gtfs'
      expect(feed.url).to eq 'http://www.bart.gov/dev/schedules/google_transit.zip'
    end

    it 'will cleanly fail when no Onestop ID or JSON blob provided' do
      expect {
        OnestopRegistry::Entities::Feed.new()
      }.to raise_error(ArgumentError)
    end

    it 'will cleanly fail when no JSON file found to go with provided Onestop ID' do
      expect {
        OnestopRegistry::Entities::Feed.new(onestop_id: 'f-9q9-NoBART')
      }.to raise_error(StandardError, 'no JSON file found with a Onestop ID of f-9q9-NoBART')
    end

    it 'has associated OperatorInFeed entities' do
      feed = OnestopRegistry::Entities::Feed.new(onestop_id: 'f-9q9-BART')
      expect(feed.operators_in_feed.count).to eq 1
      expect(feed.operators_in_feed.first.gtfs_agency_id).to eq 'BART'
      expect(feed.operators_in_feed.first.operator.name).to eq 'San Francisco Bay Area Rapid Transit District'
      expect(feed.operators_in_feed.first.operator.onestop_id).to eq 'o-9q9-BART'
    end
  end
end
