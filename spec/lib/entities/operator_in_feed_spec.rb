require_relative '../../../lib/onestop_registry/entities/operator_in_feed'

describe OnestopRegistry::Entities::OperatorInFeed do
  it 'can be created from the feed side' do
    feed = OnestopRegistry::Entities::Feed.new(onestop_id: 'f-9q9-BART')
    expect(feed.operators_in_feed.count).to eq 1
    expect(feed.operators_in_feed.first.gtfs_agency_id).to eq 'BART'
    expect(feed.operators_in_feed.first.operator.name).to eq 'San Francisco Bay Area Rapid Transit District'
    expect(feed.operators_in_feed.first.operator.onestop_id).to eq 'o-9q9-BART'
  end

  it 'can be created from the operator side' do
    operator = OnestopRegistry::Entities::Operator.new(onestop_id: 'o-9q9-BART')
    operator_in_feed = OnestopRegistry::Entities::OperatorInFeed.new(
      operator: operator,
      feed_onestop_id: 'f-9q9-BART'
    )
    # TODO: handle this? expect(operator_in_feed.gtfs_agency_id).to eq 'BART'
    expect(operator_in_feed.operator.name).to eq 'San Francisco Bay Area Rapid Transit District'
    expect(operator_in_feed.operator.onestop_id).to eq 'o-9q9-BART'
    expect(operator_in_feed.feed.onestop_id).to eq 'f-9q9-BART'
  end

  it 'fails gracefully when not enough arguments provided' do
    expect {
      OnestopRegistry::Entities::OperatorInFeed.new()
    }.to raise_error(ArgumentError)

    expect {
      OnestopRegistry::Entities::OperatorInFeed.new(feed_onestop_id: 'f-9q9-BART')
    }.to raise_error(ArgumentError)

    expect {
      OnestopRegistry::Entities::OperatorInFeed.new(operator_onestop_id: 'o-9q9-BART')
    }.to raise_error(ArgumentError)
  end
end
