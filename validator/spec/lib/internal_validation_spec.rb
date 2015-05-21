describe TransitlandFeedRegistryValidator do
  it 'succeeds on a complete feed' do
    validation_results = TransitlandFeedRegistryValidator.validate(:feeds, '
      {
        "onestopId": "f-9q9-ACTransit",
        "url": "http://www.actransit.org/wp-content/uploads/gtfsdec072014b.zip",
        "feedFormat": "gtfs",
        "tags": {
          "license": "Creative Commons Attribution 3.0 Unported License",
          "licenseUrl": "http://www.actransit.org/data-terms-and-conditions/"
        },
        "operatorsInFeed": [
          {
            "onestopId": "o-9q9-ACTransit",
            "gtfsAgencyId": "AC Transit",
            "identifiers": ["usntd://9015"]
          }
        ],
        "sha1": "daa768c1c5c6b8cf32acc800820dbc0b5d8e9191"
      }
    ')
    expect(validation_results.count).to eq 0
  end

  it 'catch a missing OnestopID on OperatorInFeed' do
    validation_results = TransitlandFeedRegistryValidator.validate(:feeds, '
      {
        "onestopId": "f-9q9-ACTransit",
        "url": "http://www.actransit.org/wp-content/uploads/gtfsdec072014b.zip",
        "feedFormat": "gtfs",
        "tags": {
          "license": "Creative Commons Attribution 3.0 Unported License",
          "licenseUrl": "http://www.actransit.org/data-terms-and-conditions/"
        },
        "operatorsInFeed": [
          {
            "gtfsAgencyId": "AC Transit",
            "identifiers": ["usntd://9015"]
          }
        ],
        "sha1": "daa768c1c5c6b8cf32acc800820dbc0b5d8e9191"
      }
    ')
    expect(validation_results.count).to be > 0
    expect(validation_results[1][:fragment]).to eq '#/operatorsInFeed/0'
    expect(validation_results[1][:message]).to include "The property '#/operatorsInFeed/0' did not contain a required property of 'onestopId'"
  end

  it 'catch a badly formed OnestopID on OperatorInFeed' do
    validation_results = TransitlandFeedRegistryValidator.validate(:feeds, '
      {
        "onestopId": "f-9q9-ACTransit",
        "url": "http://www.actransit.org/wp-content/uploads/gtfsdec072014b.zip",
        "feedFormat": "gtfs",
        "tags": {
          "license": "Creative Commons Attribution 3.0 Unported License",
          "licenseUrl": "http://www.actransit.org/data-terms-and-conditions/"
        },
        "operatorsInFeed": [
          {
            "onestopId": "9q9-ACTransit",
            "gtfsAgencyId": "AC Transit",
            "identifiers": ["usntd://9015"]
          }
        ],
        "sha1": "daa768c1c5c6b8cf32acc800820dbc0b5d8e9191"
      }
    ')
    expect(validation_results.count).to be > 0
    expect(validation_results[0][:fragment]).to eq '#/operatorsInFeed/0/onestopId'
    expect(validation_results[0][:message]).to include "
      The property '#/operatorsInFeed/0/onestopId' must include 3 components separated by hyphens (\"-\"),
      must start with \"o\" as its 1st component,
      must include a valid geohash as its 2nd component,
      must include only letters and digits in its abbreviated name (the 3rd component)".strip.gsub(/[ ]{2,}/, ' ').gsub(/\n/, '')
  end

  it 'catch a badly formed sha1 hash' do
    validation_results = TransitlandFeedRegistryValidator.validate(:feeds, '
      {
        "onestopId": "f-9q9-ACTransit",
        "url": "http://www.actransit.org/wp-content/uploads/gtfsdec072014b.zip",
        "feedFormat": "gtfs",
        "tags": {
          "license": "Creative Commons Attribution 3.0 Unported License",
          "licenseUrl": "http://www.actransit.org/data-terms-and-conditions/"
        },
        "operatorsInFeed": [
          {
            "onestopId": "o-9q9-ACTransit",
            "gtfsAgencyId": "AC Transit",
            "identifiers": ["usntd://9015"]
          }
        ],
        "sha1": "daa768c1c5c6b8cf30082b5d8e9191"
      }
    ')
    expect(validation_results.count).to be > 0
    expect(validation_results[0][:fragment]).to eq '#/sha1'
  end

  it 'will run internal validations on all the appropriate files' do
    stub_const("TransitlandFeedRegistryValidator::FEED_FOLDER", File.join(__dir__, '..', 'test_data'))
    allow(TransitlandFeedRegistryValidator).to receive(:validate).and_return([])
    expect { TransitlandFeedRegistryValidator.validate_return_errors_and_exit }.to raise_error(SystemExit)
    expect(TransitlandFeedRegistryValidator).to have_received(:validate).exactly(2).times
  end
end
