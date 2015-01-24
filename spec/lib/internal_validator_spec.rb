require_relative '../../lib/onestop_registry'

describe OnestopRegistry::InternalValidator do
  context 'operators' do
    it 'succeeds on a complete operator' do
      validation_results = OnestopRegistry::InternalValidator.validate(:operators, '
        {
          "onestopId": "o-9q8y-SFMTA",
          "name": "San Francisco Municipal Transportation Agency",
          "tags": {
            "us_national_transit_database_id": 9015,
            "website": "http://www.sfmta.com",
            "timezone": "America/Los_Angeles"
          },
          "identifiers": [
            { "identifier": "MUNI" },
            { "identifier": "SFMTA" }
          ],
          "geometry": {
            "type": "Polygon",
            "coordinates": [[
              [-122.53867,37.83238],
              [-122.506821,37.735482],
              [-122.500028,37.718996],
              [-122.499913,37.718738],
              [-122.49766,37.71677],
              [-122.485294,37.709312],
              [-122.48498,37.70913],
              [-122.469273,37.705764],
              [-122.413084,37.706296],
              [-122.39422,37.70898],
              [-122.392836,37.709804],
              [-122.365447,37.72792],
              [-122.36633,37.820001],
              [-122.371964,37.828311],
              [-122.373477,37.82982],
              [-122.48383,37.83592],
              [-122.50214,37.836443],
              [-122.53867,37.83238]
            ]]
          }
        }
      ')
      expect(validation_results.count).to eq 0
    end

    it 'catch a missing OnestopID on operator' do
      validation_results = OnestopRegistry::InternalValidator.validate(:feeds, '
        {
          "name": "San Francisco Bay Area Rapid Transit District",
          "tags": {
            "us_national_transit_database_id": 9003,
            "website": "http://www.bart.gov",
            "timezone": "America/Los_Angeles"
          },
          "identifiers": [
            { "identifier": "BART" }
          ],
          "geometry": {
            "type": "Polygon",
            "coordinates": [[
              [-122.4690807,37.70612055],
              [-122.466233,37.684638],
              [-122.38666,37.599787],
              [-121.9764,37.557355],
              [-121.900367,37.701695],
              [-121.945154,38.018914],
              [-122.024597,38.003275],
              [-122.353165,37.936887],
              [-122.4690807,37.70612055]
            ]]
          }
        }

      ')
      expect(validation_results.count).to be > 0
      expect(validation_results[0][:fragment]).to eq '#/'
      expect(validation_results[0][:message]).to include "The property '#/' did not contain a required property of 'onestopId'"
    end
  end

  context 'feeds' do
    it 'succeeds on a complete feed' do
      validation_results = OnestopRegistry::InternalValidator.validate(:feeds, '
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
              "gtfsAgencyId": "AC Transit"
            }
          ]
        }
      ')
      expect(validation_results.count).to eq 0
    end

    it 'catch a missing OnestopID on OperatorInFeed' do
      validation_results = OnestopRegistry::InternalValidator.validate(:feeds, '
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
              "gtfsAgencyId": "AC Transit"
            }
          ]
        }
      ')
      expect(validation_results.count).to be > 0
      expect(validation_results[0][:fragment]).to eq '#/operatorsInFeed/0'
      expect(validation_results[0][:message]).to include "The property '#/operatorsInFeed/0' did not contain a required property of 'onestopId'"
    end

    it 'catch a badly formed OnestopID on OperatorInFeed' do
      validation_results = OnestopRegistry::InternalValidator.validate(:feeds, '
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
              "gtfsAgencyId": "AC Transit"
            }
          ]
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
  end

  context 'all' do
    it 'will run internal validations on all the appropriate files' do
      number_of_json_files_to_validate = ['feeds', 'operators'].map {
        |entity| Dir[File.join(__dir__, '..', '..', entity, '*.json')].count { |file| File.file?(file) }
      }.inject(:+)
      allow(OnestopRegistry::InternalValidator).to receive(:validate).and_return([])
      expect { OnestopRegistry::InternalValidator.validate_all }.to raise_error(SystemExit)
      expect(OnestopRegistry::InternalValidator).to have_received(:validate).exactly(number_of_json_files_to_validate).times
    end
  end
end
